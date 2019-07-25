//
//  Date.h
//  Mytinerary
//
//  Created by ehhong on 7/25/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Date : NSObject

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end

NS_ASSUME_NONNULL_END
