//
//  DailyCalendarViewController.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"
#import "WeekdayCollectionViewCell.h"
#import "DailyCalendarEventUIView.h"
#import "EventDetailsViewController.h"
#import "ItineraryDetailsViewController.h"
#import "InputEventViewController.h"
#import "MapViewController.h"
#import "Event.h"
#import "DateFormatter.h"
#import "FSCalendar.h"
#import "Parse/Parse.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource, CalendarEventViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation DailyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.timeOfDayFormatter setDateFormat:@"HH:mm:ss"];
    
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [self.calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.WeeklyCalendarCollectionView.dataSource = self;
    self.WeeklyCalendarCollectionView.delegate = self;
    
    // load calendar table view
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [DateFormatter timeOfDayFormatter];
    // set up table view
    self.tableView.rowHeight = 200;
    
    // if from login, itinerary obj must be fetched first
    if (self.fromLogin) {
        [self fetchItineraryAndLoadView];
    }
    else {
        [self loadItinView];
    }
}

- (void)fetchItineraryAndLoadView {
    // set up activity indicator -- TODO: not sure if this actually works
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
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
            [self refreshViewUsingDate:[self.calendar startOfDayForDate:self.itinerary.startTime]];
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}


#pragma mark - Data Handling

-(void)refreshViewUsingDate:(NSDate *)newDate {
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


#pragma mark - Table & Collection Views

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyEventCell" forIndexPath:indexPath];
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
    NSDate *date = allDates[indexPath.item];
    cell.date = date;
    
    // take information from startdate and add it to cell
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSArray *weekdayArray = [NSArray arrayWithObjects: @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    cell.weekdayLabel.text = [NSString stringWithFormat:@"%@", weekdayArray[([dateComponents weekday])-1]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)[dateComponents day]];
    
    NSArray *individualDayEvents = [NSArray arrayWithArray:self.eventsDictionary[date]];
    cell.eventArray = individualDayEvents;
//    NSLog(@"self.eventsDictionary = %@", self.eventsDictionary);
//    NSLog(@"\n\nFor date:%@, individualDayEvents = %@", date, individualDayEvents);
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.eventsDictionary.count;     // dictionary has 1 entry per day in itinerary
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // reset the tableview and all the sheiza on it
    WeekdayCollectionViewCell *cell = (WeekdayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.dateLabel.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1];
    // NSLog(@"tapped cell's Date [7 hours behind] = %@", cell.date);
    [self refreshViewUsingDate:cell.date];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeekdayCollectionViewCell *cell = (WeekdayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.dateLabel.backgroundColor = [UIColor colorWithRed:.2 green:.6 blue:.99 alpha:1];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"eventDetailsSegue"]) {
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.event = sender;
    }
    else if ([[segue identifier] isEqualToString:@"addEventSegue"]) {
        // send itinerary to input event VC to add new event to appropriate itinerary
        InputEventViewController *inputEventViewController = [segue destinationViewController];
        inputEventViewController.itinerary = self.itinerary;
    }
    else if ([[segue identifier] isEqualToString:@"itineraryDetailsSegue"]) {
        ItineraryDetailsViewController *itineraryDetailsViewController = [segue destinationViewController];
        itineraryDetailsViewController.itinerary = self.itinerary;
    }
}


- (void)calendarEventView:(nonnull DailyCalendarEventUIView *)calendarEventView didTapEvent:(nonnull Event *)event {
    [self performSegueWithIdentifier:@"eventDetailsSegue" sender:event];
}

- (IBAction)onTapMapButton:(id)sender {
    // navigate to map by resetting nav controller view controller stack
    
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItineraryNavigationController"];
    
    MapViewController *mapViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
    // TODO: pass itinerary from daily calendar to map
    
    [navigationController setViewControllers:[NSArray arrayWithObject:mapViewController]];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)onTapAddEventButton:(id)sender {
    [self performSegueWithIdentifier:@"addEventSegue" sender:self];
}

- (void)onTapItineraryTitle {
    [self performSegueWithIdentifier:@"itineraryDetailsSegue" sender:nil];
}


@end
