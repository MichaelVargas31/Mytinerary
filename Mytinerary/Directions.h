//
//  Directions.h
//  Mytinerary
//
//  Created by ehhong on 7/29/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Directions : NSObject

+ (void)getDirectionsLatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng withCompletion:(MKDirectionsHandler _Nonnull)completion;

@end

NS_ASSUME_NONNULL_END
