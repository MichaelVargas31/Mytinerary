//
//  Calendar.m
//  Mytinerary
//
//  Created by michaelvargas on 8/1/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "Calendar.h"

@implementation Calendar

+ (NSCalendar *)gregorianCalendarWithUTCTimeZone {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return calendar;
}

@end
