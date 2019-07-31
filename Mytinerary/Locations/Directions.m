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

// NEEDS TO BE TESTED
+ (void)getDirectionsLatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng withCompletion:(MKDirectionsHandler _Nonnull)completion {
    
    // initialize placemarks from lat/lng
    NSArray *placemarks = [self getPlacemarksLatLng:startLat startLng:startLng endLat:endLat endLng:endLng];
    MKPlacemark *startPlacemark = [placemarks firstObject];
    MKPlacemark *endPlacemark = [placemarks lastObject];
    
    MKMapItem *startMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    // create the directions request
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:startMapItem];
    [request setDestination:endMapItem];
    
    // CHANGE DEFAULT IF NECESSARY
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:completion];
}

+ (NSArray <MKPlacemark *> *)getPlacemarksLatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng {
    // initialize placemarks from lat/lng
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(startLat.doubleValue, startLng.doubleValue);
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate];
    
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake(endLat.doubleValue, endLng.doubleValue);
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate];
    
    return [NSArray arrayWithObjects:startPlacemark, endPlacemark, nil];
}

+ (NSArray <MKPlacemark *> *)getTransportationEventPlacemarks:(Event *)event {
    // if not a transpo event
    if (![event.category isEqualToString:@"transportation"]) {
        return nil;
    }
    
    return [self getPlacemarksLatLng:event.latitude startLng:event.longitude endLat:event.endLatitude endLng:event.endLongitude];
}

// TODO: create transportation event between two events
- (MKDirections *)getDirectionsToFromEvents:(Event *)startEvent endEvent:(Event *)endEvent {
    return nil;
}

+ (void)openTransportationEventInMaps:(Event *)event {
    // get placemarks for start/end locations, turn into map items
    NSArray <MKPlacemark *> *placemarks = [Directions getTransportationEventPlacemarks:event];
    MKMapItem *startMapItem = [[MKMapItem alloc] initWithPlacemark:[placemarks firstObject]];
    MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:[placemarks lastObject]];
    
    // get names for map items from event title: "______ to _______", use address o/w
    NSString *startLocationName = [[NSString alloc] init];
    NSString *endLocationName = [[NSString alloc] init];
    if ([event.title containsString:@" to "]) {
        NSRange range = [event.title rangeOfString:@" to "];
        startLocationName = [event.title substringToIndex:range.location];
        endLocationName = [event.title substringFromIndex:(range.location + range.length)];
    }
    else {
        startLocationName = event.address;
        endLocationName = event.endAddress;
    }
    [startMapItem setName:startLocationName];
    [endMapItem setName:endLocationName];
    
    // launch maps
    //  take transportation mode preference from event
    NSString *transportationMode = [[NSString alloc] init];
    if ([event.transpoType isEqualToString:@"drive"]) {
        transportationMode = MKLaunchOptionsDirectionsModeDriving;
    }
    else if ([event.transpoType isEqualToString:@"walk"]) {
        transportationMode = MKLaunchOptionsDirectionsModeWalking;
    }
    else if ([event.transpoType isEqualToString:@"transit"]) {
        transportationMode = MKLaunchOptionsDirectionsModeTransit;
    }
    else {
        transportationMode = MKLaunchOptionsDirectionsModeDefault;
    }
    NSDictionary<NSString *, id> *options = @{MKLaunchOptionsDirectionsModeKey: transportationMode};
    NSArray<MKMapItem *> *mapItems = [NSArray arrayWithObjects:startMapItem, endMapItem, nil];
    [MKMapItem openMapsWithItems:mapItems launchOptions:options];
}

@end
