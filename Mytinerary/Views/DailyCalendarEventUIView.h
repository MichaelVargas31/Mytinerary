//
//  DailyCalendarEventUIView.h
//  Mytinerary
//
//  Created by michaelvargas on 7/19/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CalendarEventViewDelegate;

@interface DailyCalendarEventUIView : UIView

@property (nonatomic, weak) id<CalendarEventViewDelegate> delegate;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) UILabel *eventTitleLabel;
@property double topBorder;
@property double eventLength;

- (void)createEventViewWithEventModel:(Event *)event;

@end

// protocol to pass data from event view --> calendar VC --> event details view
@protocol CalendarEventViewDelegate

- (void)calendarEventView:(DailyCalendarEventUIView *)calendarEventView didTapEvent:(Event *)event;

@end

NS_ASSUME_NONNULL_END
