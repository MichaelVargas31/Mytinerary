//
//  DailyCalendarEventUIView.m
//  Mytinerary
//
//  Created by michaelvargas on 7/19/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DailyCalendarEventUIView.h"
#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"
#import "Colors.h"

@implementation DailyCalendarEventUIView

- (void)createEventViewWithEventModel:(Event *)event {
    // assign event as view property
    self.event = event;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    
    NSDateComponents *eventStartComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:event.startTime];
    NSInteger eventStartHour = [eventStartComponents hour];
    NSInteger eventStartMinute = [eventStartComponents minute];
    NSDateComponents *eventEndComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:event.endTime];
    NSInteger eventEndHour = [eventEndComponents hour];
    NSInteger eventEndMinute = [eventEndComponents minute];
    
    // distance from top = HOURS*rowheight*2 + (MINS/30)*rowheight
    long rowHeight = [DailyTableViewCell returnRowHeight].unsignedLongValue;
    
    self.topBorder = (eventStartHour * rowHeight)*2 + ((eventStartMinute/30.0) * rowHeight);
    self.eventLength = (eventEndHour * rowHeight)*2 + ((eventEndMinute/30.0) * rowHeight) - self.topBorder;
    
    // Configuring appearance of the cell
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [self setFrame:CGRectMake(60, self.topBorder, screenWidth - 68, self.eventLength)];
    
    if ([event.category isEqualToString:@"activity"]) {
        self.backgroundColor = [Colors goldColor];
        [self addLeftBorderWithColor:[Colors darkGoldColor] andWidth:3.0f];
    }
    else if ([event.category isEqualToString:@"transportation"]) {
        self.backgroundColor = [Colors purpleColor];
        [self addLeftBorderWithColor:[Colors darkPurpleColor] andWidth:3.0f];
    }
    else if ([event.category isEqualToString:@"food"]) {
        self.backgroundColor = [Colors redColor];
        [self addLeftBorderWithColor:[Colors darkRedColor] andWidth:3.0f];
    }
    else if ([event.category isEqualToString:@"hotel"]) {
        self.backgroundColor = [Colors blueColor];
        [self addLeftBorderWithColor:[Colors darkBlueColor] andWidth:3.0f];
    }
    
    [self setAlpha:.75];
    
    // Adding title label
    UILabel *eventNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, screenWidth - 68 - 16, 20)];
    [eventNameLabel setTextColor:[UIColor blackColor]];
    [eventNameLabel setFont:[UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium]];
    eventNameLabel.text = event.title;
    [eventNameLabel sizeToFit];
    [self addSubview:eventNameLabel];
    
    // Add tap gesture recognizer
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *eventTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEvent:)];
    [self addGestureRecognizer:eventTap];
}

//https://stackoverflow.com/questions/17355280/how-to-add-a-border-just-on-the-top-side-of-a-uiview
- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [self addSubview:border];
}

- (void)didTapEvent:(UITapGestureRecognizer *)sender {
    // when event is tapped, launch event details view
    // initiate segue to details view, pass event in as sender
    [self.delegate calendarEventView:self didTapEvent:self.event];
}




@end
