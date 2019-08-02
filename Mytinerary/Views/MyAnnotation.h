//
//  MyAnnotation.h
//  Mytinerary
//
//  Created by samason1 on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) int group;

@end


