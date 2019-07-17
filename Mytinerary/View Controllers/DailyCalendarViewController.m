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
    
    
    // test
    UIView *paintView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 430)];
    [paintView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:paintView];
//    [paintView release];
    [self.tableView addSubview:paintView]; // will this work??? IT DOES
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyEventCell" forIndexPath:indexPath];
    
    // Only for testing until we can actually take data and things
    // self.eventArray = [];
    NSDictionary *event = self.eventArray[indexPath.item];
    
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
    
    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    NSDate *testDate = [self.timeOfDayFormatter dateFromString:@"05:30:00"];
    NSDateInterval *timeFromMidnight = [midnight initWithTimeIntervalSinceReferenceDate:testDate];
    
    
    
}


@end
