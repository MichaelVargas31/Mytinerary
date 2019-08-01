//
//  Calendar.h
//  Mytinerary
//
//  Created by michaelvargas on 8/1/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calendar : NSObject

// Reduces redundant code, ensures time zone is always set
+ (NSCalendar *)gregorianCalendarWithUTCTimeZone;

@end

NS_ASSUME_NONNULL_END
