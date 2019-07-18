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
        - But can I add coordinates to the event to make sure it spans the timeframe?
 
 
    Maybe NSCalendar could be useful?

 
 Questions:
    - Should formatter be defined as a property of the Daily View Controller?
    - Possible to add addEventWith() to scheduledEventView.m file?? outsourcing?
    - To add multiple events to calendar, use for loop or do it through cellForRowAtIndexPath???

 */

#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
    
    // Eventually: read through the saved event itinerary information and display it on screen
    NSDate *start = [self.timeOfDayFormatter dateFromString:@"02:15:00"];
    NSDate *end = [self.timeOfDayFormatter dateFromString:@"05:30:00"];
    [self addEventWith:start andEndDate:end];
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
    
    // Only for testing until we can actually take data and things
    // self.eventArray = [define your own test array when needed];
    NSDictionary *event = self.itinerary.events[indexPath.item];
    
    // set the cell labels with information from the event, then return;
    // or should we only add that information later with content views(?)
    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    NSDate *newTime = [midnight dateByAddingTimeInterval:1800*indexPath.row];
    cell.calendarTimeLabel.text = [[self.timeOfDayFormatter stringFromDate:newTime] substringToIndex:5];

    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 48;
}




- (void)addEventWith:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    // What exactly the date is going to look like will determine how we convert
    
//    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
//    NSDate *testDate = [self.timeOfDayFormatter dateFromString:@"05:30:00"];
//    NSTimeInterval timeFromMidnight = [midnight timeIntervalSinceDate:endDate];
    // NSTimeInterval is really just a double => no pointer needed
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *midnightComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:midnight];
//    NSInteger midnightHour = [midnightComponents hour];
//    NSInteger midnightMinute = [midnightComponents minute];
    NSDateComponents *eventStartComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    NSInteger eventStartHour = [eventStartComponents hour];
    NSInteger eventStartMinute = [eventStartComponents minute];
    NSDateComponents *eventEndComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate];
    NSInteger eventEndHour = [eventEndComponents hour];
    NSInteger eventEndMinute = [eventEndComponents minute];
    
    

    NSLog(@"hour: %ld minute:%ld", (long)eventStartHour, (long)eventStartMinute);
//    NSLog(@"Time interval: %f", timeFromMidnight);
    
    // distance from top = HOURS*rowheight*2 + (MINS/30)*rowheight
    float pixelsFromTop = (eventStartHour * self.tableView.rowHeight)*2 + ((eventStartMinute/30.0) * self.tableView.rowHeight);
    float eventLength = (eventEndHour * self.tableView.rowHeight)*2 + ((eventEndMinute/30.0) * self.tableView.rowHeight) - pixelsFromTop;
    NSLog(@"results");
    
    
    // test
//    pixelsFromTop = 800;
    UIView *paintView=[[UIView alloc]initWithFrame:CGRectMake(60, pixelsFromTop, 320, eventLength)];
    [paintView setBackgroundColor:[UIColor lightGrayColor]];
    [paintView setAlpha:.75];

    UILabel *eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [eventNameLabel setTextColor:[UIColor blackColor]];
    [eventNameLabel setBackgroundColor:[UIColor redColor]];
    [eventNameLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    eventNameLabel.text = @"event name";
    [paintView addSubview:eventNameLabel];
    
    
    
    [self.view addSubview:paintView];
    //    [paintView release];  // unsure what the purpose of this is, but may be necessary at some point
    [self.tableView addSubview:paintView]; // will this work??? IT DOES
    
}


@end
