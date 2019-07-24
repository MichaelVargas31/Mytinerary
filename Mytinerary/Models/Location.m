//
//  Location.m
//  Mytinerary
//
//  Created by ehhong on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "Location.h"

@implementation Location

// based upon dictionary returned from Google places API
+ (Location *)initWithDictionary:(NSDictionary *)dict {
    Location *location = [[Location alloc] init];
    location.name = dict[@"name"];
    location.address = dict[@"formatted_address"];
    location.latitude = dict[@"geometry"][@"location"][@"lat"];
    location.longitude = dict[@"geometry"][@"location"][@"lng"];
    location.type = [dict[@"types"] firstObject];
    
    return location;
}

// takes in an array of location dictionaries from API
+ (NSMutableArray *)initWithDictionaries:(NSArray<NSDictionary *> *)dictionaries {
    NSMutableArray *locations = [NSMutableArray array];
    for (NSDictionary *dict in dictionaries) {
        Location *location = [Location initWithDictionary:dict];
        [locations addObject:location];
    }
    return locations;
}

@end
