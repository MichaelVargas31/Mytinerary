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

- (MKAnnotationView *)annotationView {
    // for non-transportation events
    if (![self.event.category isEqualToString:@"transportation"]) {
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Pin"];
        switch (self.group) {
            case 1: // food
                pinView.pinTintColor = UIColor.purpleColor;
                break;
            case 2: // activity
                pinView.pinTintColor = UIColor.yellowColor;
                break;
            case 3: // hotel
                pinView.pinTintColor = UIColor.redColor;
                break;
            default: // should never get here
                pinView.pinTintColor = UIColor.greenColor;
                break;
        }
        pinView.annotation = self;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [pinView setRightCalloutAccessoryView:btn];
        
        return pinView;
    }
    // for transportation events
    else {
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Pin"];
        pinView.pinTintColor = UIColor.greenColor;
        pinView.annotation = self;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [pinView setRightCalloutAccessoryView:btn];
        
        return pinView;
    }
}

@end
