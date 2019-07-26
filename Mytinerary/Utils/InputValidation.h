//
//  InputValidation.h
//  Mytinerary
//
//  Created by ehhong on 7/25/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputValidation : NSObject

+ (NSString *)itineraryValidation:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime budget:(NSNumber *)budget;

+ (NSString *)eventSharedValidation:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime address:(NSString *)address;

+ (NSString *)startEndAddressValidation:(NSString *)startAddress endAddress:(NSString *)endAddress;

@end

NS_ASSUME_NONNULL_END
