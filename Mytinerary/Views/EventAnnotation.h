//
//  EventAnnotation.h
//  Mytinerary
//
//  Created by samason1 on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Event.h"

@interface EventAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) int group;
@property (nonatomic, assign) Event *event;

+ (EventAnnotation *)initAnnotationWithEventForCoordinate:(Event *)event coordinate:(CLLocationCoordinate2D)coordinate;

- (MKAnnotationView *)annotationView;

@end


