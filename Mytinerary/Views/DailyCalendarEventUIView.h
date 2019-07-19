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

@interface DailyCalendarEventUIView : UIView

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) UILabel *eventTitleLabel;
@property double topBorder;
@property double eventLength;

//- (void)createEventViewWithTitle:(NSString *)title startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
- (void)createEventViewWithEventModel:(Event *)event;


@end

NS_ASSUME_NONNULL_END
