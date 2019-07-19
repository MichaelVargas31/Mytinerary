//
//  DailyCalendarEventUIView.m
//  Mytinerary
//
//  Created by michaelvargas on 7/19/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DailyCalendarEventUIView.h"
#import "DailyTableViewCell.h"

@implementation DailyCalendarEventUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)createEventViewWithTitle:(NSString *)title startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
//    
//    //    NSLog(@"Start: %@, end %@", [self.timeOfDayFormatter stringFromDate:start], [self.timeOfDayFormatter stringFromDate:end]);
//    
//    //    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
//    
//    NSDateComponents *eventStartComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
//    NSInteger eventStartHour = [eventStartComponents hour];
//    NSInteger eventStartMinute = [eventStartComponents minute];
//    NSLog(@"time zone: %@", calendar.timeZone);
//    NSDateComponents *eventEndComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate];
//    NSInteger eventEndHour = [eventEndComponents hour];
//    NSInteger eventEndMinute = [eventEndComponents minute];
//    
//    
//    
//    NSLog(@"hour: %ld minute:%ld", (long)eventStartHour, (long)eventStartMinute);
//    //    NSLog(@"Time interval: %f", timeFromMidnight);
//    
//    // distance from top = HOURS*rowheight*2 + (MINS/30)*rowheight
//    self.topBorder = (eventStartHour * self.tableView.rowHeight)*2 + ((eventStartMinute/30.0) * self.tableView.rowHeight);
//    self.eventLength = (eventEndHour * self.tableView.rowHeight)*2 + ((eventEndMinute/30.0) * self.tableView.rowHeight) - pixelsFromTop;
//    
//    
//    // test
//    //    pixelsFromTop = 800;
//    UIView *eventView=[[UIView alloc]initWithFrame:CGRectMake(60, *(self.topBorder), 320, *(self.eventLength))];
//    [eventView setBackgroundColor:[UIColor lightGrayColor]];
//    eventView.layer.borderColor = [UIColor blueColor].CGColor;
//    eventView.layer.borderWidth = 3.0f;
//    [eventView setAlpha:.75];
//    
//    UILabel *eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
//    [eventNameLabel setTextColor:[UIColor blackColor]];
//    [eventNameLabel setBackgroundColor:[UIColor redColor]];
//    [eventNameLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
//    eventNameLabel.text = title;
//    [eventView addSubview:eventNameLabel];
//    
//    // add tap gesture recognizer
//    [eventView setUserInteractionEnabled:YES];
//    //    UIGestureRecognizer *eventTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEvent:)];
//    UITapGestureRecognizer *eventTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEvent:)];
//    [eventView addGestureRecognizer:eventTap];
//}

- (void)createEventViewWithEventModel:(Event *)event {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    
    //    NSLog(@"Start: %@, end %@", [self.timeOfDayFormatter stringFromDate:start], [self.timeOfDayFormatter stringFromDate:end]);
    //    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    
    NSDateComponents *eventStartComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:event.startTime];
    NSInteger eventStartHour = [eventStartComponents hour];
    NSInteger eventStartMinute = [eventStartComponents minute];
    NSLog(@"time zone: %@", calendar.timeZone);
    NSDateComponents *eventEndComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:event.endTime];
    NSInteger eventEndHour = [eventEndComponents hour];
    NSInteger eventEndMinute = [eventEndComponents minute];
    
    NSLog(@"hour: %ld minute:%ld", (long)eventStartHour, (long)eventStartMinute);
    //    NSLog(@"Time interval: %f", timeFromMidnight);
    
    // distance from top = HOURS*rowheight*2 + (MINS/30)*rowheight
    
    long rowHeight = [DailyTableViewCell returnRowHeight].unsignedLongValue;

    self.topBorder = (eventStartHour * rowHeight)*2 + ((eventStartMinute/30.0) * rowHeight);
    self.eventLength = (eventEndHour * rowHeight)*2 + ((eventEndMinute/30.0) * rowHeight) - self.topBorder;
    
    
    // test
    //    pixelsFromTop = 800;
//    DailyCalendarEventUIView *eventView=[[DailyCalendarEventUIView alloc]initWithFrame:CGRectMake(60, *(self.topBorder), 320, *(self.eventLength))];
    [self setFrame:CGRectMake(60, self.topBorder, 320, self.eventLength)];
    [self setBackgroundColor:[UIColor lightGrayColor]];
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 3.0f;
    [self setAlpha:.75];
    
    UILabel *eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [eventNameLabel setTextColor:[UIColor blackColor]];
    [eventNameLabel setBackgroundColor:[UIColor redColor]];
    [eventNameLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    eventNameLabel.text = event.title;
    [self addSubview:eventNameLabel];
    
    // add tap gesture recognizer
    [self setUserInteractionEnabled:YES];
    //    UIGestureRecognizer *eventTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEvent:)];
    UITapGestureRecognizer *eventTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEvent:)];
    [self addGestureRecognizer:eventTap];
}


@end
