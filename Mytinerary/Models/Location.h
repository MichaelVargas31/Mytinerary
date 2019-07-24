//
//  Location.h
//  Mytinerary
//
//  Created by ehhong on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *type;

+ (NSMutableArray *)initWithDictionaries:(NSArray<NSDictionary *> *)dictionaries;

@end

NS_ASSUME_NONNULL_END
