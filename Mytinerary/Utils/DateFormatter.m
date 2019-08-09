//
//  DateFormatter.m
//  Mytinerary
//
//  Created by ehhong on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DateFormatter.h"
#import "Calendar.h"

@implementation DateFormatter

+ (NSDateFormatter *)hourDateFormatter {
    NSCalendar *calendar = [Calendar gregorianCalendarWithUTCTimeZone];
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.timeZone = calendar.timeZone;
        formatter.dateFormat = @"h:mm a, MMM d";
    });
    return formatter;
}

+ (NSDateFormatter *)dayDateFormatter {
    NSCalendar *calendar = [Calendar gregorianCalendarWithUTCTimeZone];
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.timeZone = calendar.timeZone;
        formatter.dateFormat = @"EEEE, MMM d, yyyy";
    });
    return formatter;
}

+ (NSDateFormatter *)timeOfDayFormatter {
    NSCalendar *calendar = [Calendar gregorianCalendarWithUTCTimeZone];
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.timeZone = calendar.timeZone;
        formatter.dateFormat = @"HH:mm:ss";
    });
    return formatter;
}

@end
