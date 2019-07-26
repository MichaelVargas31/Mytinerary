//
//  DailyCalendarViewController.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"
#import "DailyCalendarEventUIView.h"
#import "EventDetailsViewController.h"
#import "ItineraryDetailsViewController.h"
#import "InputEventViewController.h"
#import "MapViewController.h"
#import "Event.h"
#import "DateFormatter.h"
#import "FSCalendar.h"
#import "Parse/Parse.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, CalendarEventViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation DailyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.itineraryFSCalendar.dataSource = self;
    self.itineraryFSCalendar.delegate = self;
    
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
    
    // initially, only the daily calendar view will be visible
    [self.itineraryFSCalendar setFrame:CGRectMake(self.itineraryFSCalendar.frame.origin.x, self.itineraryFSCalendar.frame.origin.y, self.itineraryFSCalendar.frame.size.width, 0)];
    
    NSArray *events = [NSArray arrayWithArray:self.itinerary.events];
    NSMutableArray *eventIDs = [[NSMutableArray alloc] init];
    for (int i =0; i < events.count; i ++) {
        Event *one = events[i];
        [eventIDs addObject:one.objectId];
    }
    
    PFQuery *query = [Event query];
    [query whereKey:@"objectId" containedIn:eventIDs];
    [query orderByAscending:@"startTime"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable fullEventArray, NSError * _Nullable error) {
        if (!error) {
            self.eventsArray = fullEventArray;
            
            for (int i =0; i < self.eventsArray.count; i++) {
                DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
                [calEventView createEventViewWithEventModel:self.eventsArray[i]];
                [self.tableView addSubview:calEventView];
                
                // enable tapping on calendar event to launch details
                calEventView.delegate = self;
                
                // TODO not sure if this actually works...
                [self.activityIndicator stopAnimating];
            }
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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

- (void)calendarEventView:(nonnull DailyCalendarEventUIView *)calendarEventView didTapEvent:(nonnull Event *)event {
    // after tapping event, segue to event details view
    [self performSegueWithIdentifier:@"eventDetailsSegue" sender:event];
}

- (IBAction)onTapMapButton:(id)sender {
    // navigate to map by resetting nav controller view controller stack
    
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItineraryNavigationController"];
    
    MapViewController *mapViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
    
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
