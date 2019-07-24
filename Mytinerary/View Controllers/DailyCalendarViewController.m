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
#import "InputEventViewController.h"
#import "Event.h"
#import "FSCalendar.h"
#import "Parse/Parse.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, CalendarEventViewDelegate>


@end

@implementation DailyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.itineraryFSCalendar.dataSource = self;
    self.itineraryFSCalendar.delegate = self;
    
    // initially, only the daily calendar view will be visible
    [self.itineraryFSCalendar setFrame:CGRectMake(self.itineraryFSCalendar.frame.origin.x, self.itineraryFSCalendar.frame.origin.y, self.itineraryFSCalendar.frame.size.width, 0)];
    
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.timeOfDayFormatter setDateFormat:@"HH:mm:ss"];
    
    self.tableView.rowHeight = 200;
    
    
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
            NSLog(@"  recieved:  %@", fullEventArray);
            self.eventsArray = fullEventArray;
            NSLog(@"  new array:  %@", self.eventsArray);

            for (int i =0; i < self.eventsArray.count; i++) {
                DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
                [calEventView createEventViewWithEventModel:self.eventsArray[i]];
                [self.tableView addSubview:calEventView];
                
                // enable tapping on calendar event to launch details
                calEventView.delegate = self;
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

- (IBAction)onTapAddEventButton:(id)sender {
    [self performSegueWithIdentifier:@"addEventSegue" sender:self];
}


@end
