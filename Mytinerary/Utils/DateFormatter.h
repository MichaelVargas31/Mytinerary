//
//  DateFormatter.h
//  Mytinerary
//
//  Created by ehhong on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateFormatter : NSObject

+ (NSDateFormatter *)hourDateFormatter;
+ (NSDateFormatter *)dayDateFormatter;

@end


NS_ASSUME_NONNULL_END
