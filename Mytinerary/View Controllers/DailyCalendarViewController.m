//
//  DailyCalendarViewController.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

// View Controllers
#import "DailyCalendarViewController.h"
#import "EventDetailsViewController.h"
#import "ItineraryDetailsViewController.h"
#import "InputEventViewController.h"
#import "MapViewController.h"
// Views
#import "DailyTableViewCell.h"
#import "WeekdayCollectionViewCell.h"
#import "DailyCalendarEventUIView.h"
// Models Singletons & Other
#import "AppDelegate.h"
#import "Event.h"
#import "DateFormatter.h"
#import "Calendar.h"
#import "Parse/Parse.h"
#import "Directions.h"
#import "SWRevealViewController.h"
#import "Itinerary.h"

@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource, CalendarEventViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, InputEventViewControllerDelegate, EventDetailsViewControllerDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSDate *displayedDate;
@property (strong, nonatomic) NSArray <NSDate *> *itineraryDates; // holds dates of itinerary in order

@end

@implementation DailyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.timeOfDayFormatter setDateFormat:@"HH:mm:ss"];
    
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    self.calendar = [Calendar gregorianCalendarWithUTCTimeZone];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.WeeklyCalendarCollectionView.dataSource = self;
    self.WeeklyCalendarCollectionView.delegate = self;
    
    // load calendar table view
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [DateFormatter timeOfDayFormatter];
    // set up table view
    self.tableView.rowHeight = [DailyTableViewCell returnRowHeight].floatValue;
    
    // set up activity indicator -- TODO: not sure if this actually works
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator hidesWhenStopped];
    
    // if from login, itinerary obj must be fetched first
    [self.activityIndicator startAnimating];
    if (self.loadItinerary) {
        [self fetchItineraryAndLoadView];
    }
    else {
        [self loadItinView];
    }
    
    [self sideMenus];
}

-(void)sideMenus{
    if (self.revealViewController != nil) {
        self.menuButton.target = self.revealViewController;
        self.menuButton.action = @selector(revealToggle:);
        self.revealViewController.rearViewRevealWidth = 275;
        self.revealViewController.rightViewRevealWidth = 160;
        
        self.alertButton.target= self.revealViewController;
        self.alertButton.action = @selector(rightRevealToggle:);
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.WeeklyCalendarCollectionView indexPathsForSelectedItems].count == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.WeeklyCalendarCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.WeeklyCalendarCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
}

- (void)fetchItineraryAndLoadView {
    [Itinerary fetchAllInBackground:[NSArray arrayWithObject:self.itinerary] block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            NSLog(@"itinerary successfully fetched!");
            self.itinerary = [objects firstObject];
            [self loadItinView];
        }
        else {
            NSLog(@"error fetching itinerary object: %@", error);
        }
    }];
}

- (void)loadItinView {
    // setup navigation bar title with button
    UIButton *button = [[UIButton alloc] init];
    [button setAccessibilityFrame:CGRectMake(0, 0, 100, 40)];
    [button setTitle:self.itinerary.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapItineraryTitle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    [Event fetchAllInBackground:self.itinerary.events block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self setupDayDictionary:self.itinerary.events];
            [self.WeeklyCalendarCollectionView reloadData];
            
            // on first load, show itinerary's first day by default
            NSDate *firstDay = [self.calendar startOfDayForDate:self.itinerary.startTime];
            [self refreshViewUsingDate:firstDay];
            self.displayedDate = firstDay;
            
            [self.activityIndicator stopAnimating];
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Data Handling

- (void)refreshViewUsingDate:(NSDate *)newDate {
    // make sure its the midnight version of the date
    newDate = [self.calendar startOfDayForDate:newDate];
    // remove old events from screen
    for(UIView *view in [self.tableView subviews]) {
        if ([view isKindOfClass:[DailyCalendarEventUIView class]] == YES) {
            [view removeFromSuperview];
            view.hidden = YES;
        }
    }
    
    // add the events to the array
    NSArray *thisDatesEventsArray = self.eventsDictionary[newDate];
    for (Event *event in thisDatesEventsArray) {
        DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
        [calEventView createEventViewWithEventModel:event];
        [self.tableView addSubview:calEventView];
        calEventView.delegate = self;
    }
}

// For grouping the array of events into a dictionary.
// key = NSDate [with time set to midnight]
// value = NSArray with events
- (void) setupDayDictionary:(NSArray *)eventsArray {
    // setting up looping variables
    NSDate *loopDay = [self.calendar startOfDayForDate:self.itinerary.startTime];
    NSDate *endDay = [self.calendar dateBySettingHour:0 minute:0 second:00 ofDate:self.itinerary.endTime options:0];
    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 1;
    endDay = [self.calendar dateByAddingComponents:oneDay toDate:endDay options:0];     // Include last day in loop
    NSMutableDictionary *tempEventsDict = [NSMutableDictionary dictionaryWithDictionary:self.eventsDictionary];
    
    // loop through # of days in itinerary using an NSDate
    while ([loopDay compare:endDay] == NSOrderedAscending) {
        NSMutableArray *thisDatesEvents = [[NSMutableArray alloc] init];
        
        // loop through, add if its between current loop day and next day
        for (Event *event in eventsArray) {
            if ([self.calendar isDate:event.startTime inSameDayAsDate:loopDay]){
                [thisDatesEvents addObject:event];
            }
        }
        
        // add the event array to dictionary with NSDate as key
        [tempEventsDict setObject:thisDatesEvents forKey:loopDay];
        // increment the loop day
        loopDay = [self.calendar dateByAddingComponents:oneDay toDate:loopDay options:0];
    }
    self.eventsDictionary = [NSDictionary dictionaryWithDictionary:tempEventsDict];
}

// returns date index of added event
- (NSDate *)addEventToDayDictionary:(Event *)event {
    // get the date of the updated event, change time to midnight
    NSDate *eventDate = [self.calendar startOfDayForDate:event.startTime];
    // add to day dictionary
    [self.eventsDictionary[eventDate] addObject:event];
    return eventDate;
}

- (NSDate *)updateEventInDayDictionary:(Event *)event {
    NSDate *dayDictIdx = [self.calendar startOfDayForDate:event.startTime];
    NSMutableArray *dayEvents = self.eventsDictionary[dayDictIdx];
    BOOL noMatchingEvent = true;
    
    for (int i = 0; i < dayEvents.count; i++) {
        if ([event isSameEventObj:dayEvents[i]]) {
            [dayEvents removeObject:dayEvents[i]];
            noMatchingEvent = false;
            break;
        }
    }
    
    // if no matching event, do not modify dictionary and return nil
    if (noMatchingEvent) {
        return nil;
    }
    
    // if matching event found, modify dictionary and return dict idx
    [dayEvents addObject:event];
    return dayDictIdx;
}


#pragma mark - Table & Collection Views

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyEventCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Adding time labels to each cell
    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    NSDate *newTime = [midnight dateByAddingTimeInterval:1800*indexPath.row];
    cell.calendarTimeLabel.text = [[self.timeOfDayFormatter stringFromDate:newTime] substringToIndex:5];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 48 half hour increments in day
    return 48;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WeekdayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekdayCollectionViewCell" forIndexPath:indexPath];
    
    NSMutableArray *allDates = [NSMutableArray arrayWithArray:[self.eventsDictionary allKeys]];
    allDates = (NSMutableArray *)[allDates sortedArrayUsingSelector:@selector(compare:)];
    self.itineraryDates = allDates;
    NSDate *date = allDates[indexPath.item];
    cell.date = date;
    
    // take information from startdate and add it to cell
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSArray *weekdayArray = [NSArray arrayWithObjects: @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    cell.weekdayLabel.text = [NSString stringWithFormat:@"%@", weekdayArray[([dateComponents weekday])-1]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)[dateComponents day]];
    
    NSArray *individualDayEvents = [NSArray arrayWithArray:self.eventsDictionary[date]];
    cell.eventArray = individualDayEvents;
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.eventsDictionary.count;     // dictionary has 1 entry per day in itinerary
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // reset the collection view and all the sheiza on it

    WeekdayCollectionViewCell *cell = (WeekdayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //animates dates when cell is selected
     if(cell.isSelected){
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor=[UIColor lightGrayColor];
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor=[UIColor whiteColor];
    [UIView commitAnimations];
    }
    
    [self refreshViewUsingDate:cell.date];
    self.displayedDate = cell.date;

    cell.dateLabel.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1];
    
    // only refresh view if dates have already been loaded
    if (cell.date) {
         [self refreshViewUsingDate:cell.date];
         self.displayedDate = cell.date;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeekdayCollectionViewCell *cell = (WeekdayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
   // cell.dateLabel.backgroundColor = [UIColor colorWithRed:.2 green:.6 blue:.99 alpha:1];
    }

#pragma - Transportation

// automatically makes transportations events for the currently displayed day
- (IBAction)onTapAutoTransportButton:(id)sender {
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
    NSDate *dayIdx = self.displayedDate;
    NSMutableArray <Event *> *dayEvents = self.eventsDictionary[dayIdx];
    dayEvents = [self deleteDailyTransportationEvents:dayIdx dayEvents:dayEvents];
    dayEvents = [self makeDailyTransportationEvents:dayIdx dayEvents:dayEvents];
}

- (NSMutableArray <Event *> *)deleteDailyTransportationEvents:(NSDate *)dayIdx dayEvents:(NSMutableArray <Event *> *)dayEvents {
    // find day transportation events
    NSMutableArray *transpoEventsToDelete = [[NSMutableArray alloc] init];
    for (Event *event in dayEvents) {
        if ([event.category isEqualToString:@"transportation"]) {
            [transpoEventsToDelete addObject:event];
        }
    }
    
    // delete locally and in parse
    for (Event *event in transpoEventsToDelete) {
        [dayEvents removeObject:event];
        [Event deleteEvent:event itinerary:self.itinerary withCompletion:nil];
    }
    
    return dayEvents;
}

- (NSMutableArray <Event *> *)makeDailyTransportationEvents:(NSDate *)dayIdx dayEvents:(NSMutableArray <Event *> *)dayEvents {
    // sort events in ascending order by start time
    [dayEvents sortUsingComparator:^NSComparisonResult(Event *event1, Event *event2) {
        return [event1.startTime compare:event2.startTime];
    }];
    
    int dayEventsOGLength = (int)dayEvents.count;
    
    for (int i = 0; i < dayEventsOGLength - 1; i++) {
        // sliding window -- if event pair has no transportation events, add one
        // TODO check for address matching
        Event *event1 = dayEvents[i];
        Event *event2 = dayEvents[i + 1];
        
        // if neither event is of type transportation
        if (![event1.category isEqualToString:@"transportation"] && ![event2.category isEqualToString:@"transportation"]) {
            Event *transpoEvent = [Directions makeTransportationEventFromEvents:event1 endEvent:event2 withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Successfully made transportation event");
                    
                    // add transpo object locally, refresh view
                    [self refreshViewUsingDate:dayIdx];
                    
                    // stop activity indicator on last transpo event
                    if (i == dayEventsOGLength - 2) {
                         [self.activityIndicator stopAnimating];
                    }
                }
                else {
                    NSLog(@"error making transportation event: %@", error.domain);
                }
            }];
            
            // add transpo event locally
            [dayEvents addObject:transpoEvent];
            // add transportation event to itinerary (in parse)
            [self.itinerary addEventToItinerary:transpoEvent withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"new transpo event successfully added to itin");
                }
                else {
                    NSLog(@"error adding new transpo event to itin: %@", error.domain);
                }
            }];
        }
    }
    
    return dayEvents;
}
- (IBAction)onTapMapButton:(id)sender {
    
     [self performSegueWithIdentifier:@"calendarToMapSegue" sender:nil];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"eventDetailsSegue"]) {
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.event = sender;
        eventDetailsViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"addEventSegue"]) {
        // send itinerary to input event VC to add new event to appropriate itinerary
        InputEventViewController *inputEventViewController = [segue destinationViewController];
        inputEventViewController.itinerary = self.itinerary;
        inputEventViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"itineraryDetailsSegue"]) {
        ItineraryDetailsViewController *itineraryDetailsViewController = [segue destinationViewController];
        itineraryDetailsViewController.itinerary = self.itinerary;
    } else if ([segue.identifier isEqualToString:@"calendarToMapSegue"]) {
       // tells the revealVC which segue we want it to execute next
        //passes itinerary objects to map from reveal view controller so that the sidebar on the map will work
        //segue from calendar to revealVC
       SWRevealViewController *revealVC = [segue destinationViewController];
        revealVC.nextSegue = @"toMapSegue";
        revealVC.itinerary=self.itinerary;
    }
}

- (void)calendarEventView:(nonnull DailyCalendarEventUIView *)calendarEventView didTapEvent:(nonnull Event *)event {
    [self performSegueWithIdentifier:@"eventDetailsSegue" sender:event];
}



- (IBAction)onTapAddEventBtn:(id)sender {
    [self performSegueWithIdentifier:@"addEventSegue" sender:self];
    
}

- (void)onTapItineraryTitle {
    [self performSegueWithIdentifier:@"itineraryDetailsSegue" sender:nil];
}

// refresh calendar after making new event
// flow: (new) event input --> daily calendar
- (void)didMakeEvent:(nonnull Event *)updatedEvent {
    NSDate *dayDictIdx = [self addEventToDayDictionary:updatedEvent];
    
    // deselect previously selected day
    NSUInteger deselectedDayIndex = [self.itineraryDates indexOfObject:self.displayedDate];
    NSIndexPath *deselectedIndexPath = [NSIndexPath indexPathForItem:deselectedDayIndex inSection:0];
    [self.WeeklyCalendarCollectionView deselectItemAtIndexPath:deselectedIndexPath animated:YES];
    [self collectionView:self.WeeklyCalendarCollectionView didDeselectItemAtIndexPath:deselectedIndexPath];
    
    // select day of new event
    NSUInteger selectedDayIndex = [self.itineraryDates indexOfObject:dayDictIdx];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:selectedDayIndex inSection:0];
    [self.WeeklyCalendarCollectionView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.WeeklyCalendarCollectionView didSelectItemAtIndexPath:selectedIndexPath];
}

// refresh calendar after editing event
// flow: edit event --> event details --> daily calendar
- (void)didUpdateEvent:(nonnull Event *)updatedEvent {
    NSDate *dayDictIdx = [self updateEventInDayDictionary:updatedEvent];
    if (dayDictIdx) {
        [self refreshViewUsingDate:dayDictIdx];
    }
}

- (void)didDeleteEvent:(nonnull Event *)deletedEvent {
    // get rid of the deleted event locally
    NSDate *dayIdx = [self.calendar startOfDayForDate:deletedEvent.startTime];
    NSMutableArray *dayEvents = self.eventsDictionary[dayIdx];
    [dayEvents removeObject:deletedEvent];
    
    // get rid of it in parse (update the itinerary object)
    [Event deleteEvent:deletedEvent itinerary:self.itinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully deleted '%@'", deletedEvent.title);
        }
        else {
            NSLog(@"error deleting '%@': %@", deletedEvent.title, error.domain);
        }
    }];
    
    [self refreshViewUsingDate:[self.calendar startOfDayForDate:deletedEvent.startTime]];
}

- (IBAction)didTapBackToProfile:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *profileNavigationVC = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    appDelegate.window.rootViewController = profileNavigationVC;
}

@end
