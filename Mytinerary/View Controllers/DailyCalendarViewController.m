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
    
    // setup navigation bar title with button
    UIButton *button = [[UIButton alloc] init];
    [button setAccessibilityFrame:CGRectMake(0, 0, 100, 40)];
    [button setTitle:self.itinerary.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapItineraryTitle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    // initially, only the daily calendar view will be visible
    [self.itineraryFSCalendar setFrame:CGRectMake(self.itineraryFSCalendar.frame.origin.x, self.itineraryFSCalendar.frame.origin.y, self.itineraryFSCalendar.frame.size.width, 0)];
    
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.timeOfDayFormatter setDateFormat:@"HH:mm:ss"];
    
    self.tableView.rowHeight = 200;
    
    
    [Event fetchAllInBackground:self.itinerary.events block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.eventsArray = self.itinerary.events;
            [self setupDayDictionary];
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
    // Anything you put here can't depend on information from query.
    // Its asynchonous => This line will be executed without necessary info
}

// For grouping the array of events into a dictionary.
// key = NSDate [with time set to midnight]
// value = NSArray with events
- (void) setupDayDictionary {
    
    // get the start date from itinerary, set that as first day, set the time to 12:00am
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    // setting up looping variables
    NSDate *loopDay = [calendar startOfDayForDate:self.itinerary.startTime];
    NSDate *endDay = [calendar dateBySettingHour:0 minute:0 second:00 ofDate:self.itinerary.endTime options:0];
    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 1;
    endDay = [calendar dateByAddingComponents:oneDay toDate:endDay options:0];     // Include last day in loop
    NSMutableDictionary *tempEventsDict = [NSMutableDictionary dictionaryWithDictionary:self.eventsDictionary];
    
    // loop through # of days in itinerary using an NSDate
    while ([loopDay compare:endDay] == NSOrderedAscending) {
        NSMutableArray *thisDatesEvents = [[NSMutableArray alloc] init];
        
        // loop through
        for (Event *event in self.eventsArray) {
            NSDate *loopDayPlusOne = [calendar dateByAddingComponents:oneDay toDate:loopDay options:0];
            if ([event.startTime compare:loopDay] == NSOrderedDescending && [event.startTime compare:loopDayPlusOne] == NSOrderedAscending) {
                [thisDatesEvents addObject:event];
            }
        }
        
        // add the event array to dictionary with NSDate as key
        [tempEventsDict setObject:thisDatesEvents forKey:loopDay];
        
        // increment the loop day
        loopDay = [calendar dateByAddingComponents:oneDay toDate:loopDay options:0];
    }
    self.eventsDictionary = [NSDictionary dictionaryWithDictionary:tempEventsDict];
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

- (IBAction)onTapAddEventButton:(id)sender {
    [self performSegueWithIdentifier:@"addEventSegue" sender:self];
}

- (void)onTapItineraryTitle {
    [self performSegueWithIdentifier:@"itineraryDetailsSegue" sender:nil];
}


@end
