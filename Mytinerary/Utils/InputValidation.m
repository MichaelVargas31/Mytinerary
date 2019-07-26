//
//  InputValidation.m
//  Mytinerary
//
//  Created by ehhong on 7/25/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "InputValidation.h"

@implementation InputValidation

+ (NSString *)itineraryValidation:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime budget:(NSNumber *)budget {
    // title required
    if ([title isEqualToString:@""]) {
        return @"Missing itinerary title";
    }
    
    // ensure start and end times are valid
    if ([startTime compare:endTime] != NSOrderedAscending) {
        return @"End time must be after start time";
    }
    
    // check budget validity
    if (budget < 0) {
        return @"Budget cannot be negative";
    }
    
    // success
    return @"";
}

@end
