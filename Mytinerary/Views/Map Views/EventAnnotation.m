//
//  EventAnnotation.m
//  Mytinerary
//
//  Created by samason1 on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "EventAnnotation.h"

@implementation EventAnnotation
@synthesize coordinate, title, subtitle;

+ (EventAnnotation *)initAnnotationWithEventForCoordinate:(Event *)event coordinate:(CLLocationCoordinate2D)coordinate {
    EventAnnotation* annotation= [[EventAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = event.title;
    annotation.event = event;
    
    if ([event.category isEqualToString:@"transportation"]) {
        annotation.subtitle = event.transpoType;
    }
    return annotation;
}

@end
