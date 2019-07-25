//
//  DateFormatter.m
//  Mytinerary
//
//  Created by ehhong on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+ (NSDateFormatter *)formatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"h:mm a, MMM d";
    });
    return formatter;
}

@end
