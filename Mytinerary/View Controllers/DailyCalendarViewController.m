//
//  DailyCalendarViewController.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//


/*
 Brainstorming:
    - Probably going to have increments of 15(?) minutes that are cells
    - Use gesture recognizer to detect tap, which adds UIView to the screen?
 
    Maybe NSCalendar could be useful?

 
 Questions:
    - Should formatter be defined as a property of the Daily View Controller?
    - Possible to add addEventWith() to scheduledEventView.m file?? outsourcing?
    - Currently iterating through 'events' array of pointers in itinerary, using the ID to fetch said
            event from parse. More efficient way?
    - How can I move addEvent() to its own "View"?
    - How do I access the tableview.rowheight from the UIView file?

 */

#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"
#import "DailyCalendarEventUIView.h"
#import "Event.h"
#import "Parse/Parse.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource, CalendarEventViewDelegate>

@end

@implementation DailyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.timeOfDayFormatter setDateFormat:@"HH:mm:ss"];
    
    self.tableView.rowHeight = 200;
    
//    NSLog(@"Recieved itinerary with events: %@", self.itinerary.events);
    
    for (NSInteger i = 0; i < self.itinerary.events.count; i++) {
        Event *event = self.itinerary.events[i];
        [event fetchIfNeeded];  // might be whats taking long time
        
        // Create event & add to tableView
        DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
        [calEventView createEventViewWithEventModel:event];
        [self.tableView addSubview:calEventView]; // will this work??? IT should... if calEventView is being modified at all?
        
        // enable usage of protocol to pass data back to VC
        calEventView.delegate = self;
        
    }
}


/*
#pragma mark - Navigationr

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [self performSegueWithIdentifier:@"eventDetailsSegue" sender:self];
}

@end
