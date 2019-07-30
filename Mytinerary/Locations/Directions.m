//
//  Directions.m
//  Mytinerary
//
//  Created by ehhong on 7/29/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Directions.h"
#import "Event.h"

@implementation Directions

+ (void)getDirectionsLatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng withCompletion:(MKDirectionsHandler _Nonnull)completion {
    
    // initialize placemarks from lat/lng
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(startLat.doubleValue, startLng.doubleValue);
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate];
    MKMapItem *startMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake(endLat.doubleValue, endLng.doubleValue);
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate];
    MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    // create the directions request
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:startMapItem];
    [request setDestination:endMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:completion];
}

// TODO: create transportation event between two events
- (MKDirections *)getDirectionsToFromEvents:(Event *)startEvent endEvent:(Event *)endEvent {
    return nil;
}

@end
