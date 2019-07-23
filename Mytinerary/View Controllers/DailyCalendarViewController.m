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
#import "Event.h"
#import "FSCalendar.h"
#import "Parse/Parse.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate>

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
    
    
    // store events in temporary mutable array
    NSMutableArray *tempEventArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.itinerary.events.count; i++) {
        Event *event = self.itinerary.events[i];
        [event fetchIfNeeded];  // might be whats taking long time
        [tempEventArray addObject:event];
        NSLog(@"Event arraY: %@", tempEventArray);
    }
    
    // sort events  [ERROR CHECK WHEN WE HAVE MORE EVENTS]
    [tempEventArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull event1, id  _Nonnull event2) {
        NSDate *first = [event1 startTime];
        NSDate *second = [event2 startTime];
        return [first compare:second];
    }];
    self.sortedEventsArray = [NSArray arrayWithArray:tempEventArray];
    
    // now add sorted onto tableView
    // If events overlap incorrectly, it may be because we are sorting in the opposite direction
    for (NSInteger i = self.sortedEventsArray.count; i > 0; i--) {
        // Create event & add to tableView
        DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
        [calEventView createEventViewWithEventModel:self.sortedEventsArray[i-1]];
        [self.tableView addSubview:calEventView]; // will this work??? IT should... if calEventView is being modified at all?
        
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

- (void)didTapEvent:(UITapGestureRecognizer *)sender {
    NSLog(@"tapping: %@", self);
}


@end
