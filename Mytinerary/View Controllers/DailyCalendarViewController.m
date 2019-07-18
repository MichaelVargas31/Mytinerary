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
    - Currently iterating through 'events' array of pointers in itinerary, using the ID to fetch said
            event from parse. More efficient way?

 */

#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"
#import "Event.h"
#import "Parse/Parse.h"


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
    
    
//    NSLog(@"Recieved itinerary with events: %@", self.itinerary.events);
    
    for (NSInteger i = 0; i < self.itinerary.events.count; i++) {
        Event *event = self.itinerary.events[i];
        [event fetchIfNeeded];
        
//        [event fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//            if (!error) {
//                NSLog(@"recieved: %@", object);
////                event = object;
//
//            } else {
//                NSLog(@"[DailyCalVC] error getting individual event: %@", error.localizedDescription);
//            }
//        }];
        
        NSLog(@"event: %@", event);
        NSString *title = event.title;
        NSDate *start = event.startTime;
//        NSDate *start = event.startTime;
        NSDate *end   = event.endTime;
        NSLog(@"Start: %@, end %@", [self.timeOfDayFormatter stringFromDate:start], [self.timeOfDayFormatter stringFromDate:end]);
        [self addEventWithTitle:title startDate:start andEndDate:end];

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
    
    // Only for testing until we can actually take data and things
    // self.eventArray = [define your own test array when needed];
    //    NSDictionary *event = self.itinerary.events[indexPath.item];      // you can't do this, #events != #cells
    
    
    // Adding time labels to each cell
    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    NSDate *newTime = [midnight dateByAddingTimeInterval:1800*indexPath.row];
    cell.calendarTimeLabel.text = [[self.timeOfDayFormatter stringFromDate:newTime] substringToIndex:5];
    
    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 48;
}




- (void)addEventWithTitle:(NSString *)title startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];

    
//    NSLog(@"Start: %@, end %@", [self.timeOfDayFormatter stringFromDate:start], [self.timeOfDayFormatter stringFromDate:end]);

    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterNoStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    NSString *startstring = [formatter stringFromDate:startDate];
//    NSLog(@"startstring: %@", startstring);

//    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    
//    NSDateComponents *midnightComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:midnight];
//    NSInteger midnightHour = [midnightComponents hour];
//    NSInteger midnightMinute = [midnightComponents minute];
    NSDateComponents *eventStartComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    NSInteger eventStartHour = [eventStartComponents hour];
    NSInteger eventStartMinute = [eventStartComponents minute];
    NSLog(@"time zone: %@", calendar.timeZone);
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
    UIView *eventView=[[UIView alloc]initWithFrame:CGRectMake(60, pixelsFromTop, 320, eventLength)];
    [eventView setBackgroundColor:[UIColor lightGrayColor]];
    eventView.layer.borderColor = [UIColor blueColor].CGColor;
    eventView.layer.borderWidth = 3.0f;
    [eventView setAlpha:.75];

    UILabel *eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [eventNameLabel setTextColor:[UIColor blackColor]];
    [eventNameLabel setBackgroundColor:[UIColor redColor]];
    [eventNameLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    eventNameLabel.text = title;
    [eventView addSubview:eventNameLabel];
    
    
    
    [self.view addSubview:eventView];
    //    [paintView release];  // unsure what the purpose of this is, but may be necessary at some point
    [self.tableView addSubview:eventView]; // will this work??? IT DOES
    
}


@end
