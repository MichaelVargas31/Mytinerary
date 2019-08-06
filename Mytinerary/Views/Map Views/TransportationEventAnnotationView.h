//
//  TransportationEventAnnotationView.h
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "EventAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransportationEventAnnotationView : MKAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

- (void)assignTranspoImage:(EventAnnotation *)eventAnnotation;

@end

NS_ASSUME_NONNULL_END
