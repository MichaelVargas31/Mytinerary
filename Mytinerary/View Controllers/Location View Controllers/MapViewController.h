//
//  MapViewController.h
//  Mytinerary
//
//  Created by samason1 on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKAnnotation;

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSArray *eArray;
@property (nonatomic, strong) MKAnnotationView *pin;

// emily did this, ask her about it
@property (nonatomic, strong) Itinerary *itinerary;

@end

@interface NSNumber (MyCGFloatValue)
-(CGFloat)myCGFloatValue;
@end

@protocol MKAnnotationView

//- (void)addAnnotation:(id <MKAnnotationView>)annotation;
- (MKAnnotationView *)viewForAnnotation:(id)annotation;

@end

NS_ASSUME_NONNULL_END
