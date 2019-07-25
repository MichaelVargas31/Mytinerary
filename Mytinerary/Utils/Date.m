//
//  Date.m
//  Mytinerary
//
//  Created by ehhong on 7/25/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "Date.h"

@implementation Date

// copied from https://stackoverflow.com/questions/4739483/number-of-days-between-two-nsdates
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day] + 1;
}

@end
