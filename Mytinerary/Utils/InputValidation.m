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
    if (budget.floatValue < 0) {
        return @"Budget cannot be negative";
    }
    
    // success
    return @"";
}

+ (NSString *)eventSharedValidation:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime address:(NSString *)address {
    // title is required
    if ([title isEqualToString:@""]) {
        return @"Please add a title";
    }
    // ensure start and end time validity
    if ([startTime compare:endTime] != NSOrderedAscending) {
        return @"Start time must be before end time";
    }
    
    // address is required
    if (!address || [address isEqualToString:@""]) {
        return @"Please add a location";
    }
    // success
    return @"";
}

// start/end address are required for transportation events
+ (NSString *)startEndAddressValidation:(NSString *)startAddress endAddress:(NSString *)endAddress {
    if (!startAddress || [startAddress isEqualToString:@""]) {
        return @"Please add a start location";
    }
    if (!endAddress || [endAddress isEqualToString:@""]) {
        return @"Please add an end location";
    }
    return @"";
}

@end
