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

+ (MKDirections *)getMKDirectionsFromMapItems:(MKMapItem *)startMapItem endMapItem:(MKMapItem *)endMapItem departureDate:(NSDate *)departureDate {
    // create the directions request
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:startMapItem];
    [request setDestination:endMapItem];
    
    // CHANGE DEFAULT IF NECESSARY
    [request setTransportType:MKDirectionsTransportTypeAny];
    [request setRequestsAlternateRoutes:YES];
    [request setDepartureDate:departureDate];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    return directions;
}

+ (void)getDirectionsLatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng departureDate:(NSDate *)departureDate withCompletion:(MKDirectionsHandler _Nonnull)completion {
    // initialize placemarks from lat/lng
    NSArray *mapItems = [self getMapItemsWithLatLng:startLat startLng:startLng endLat:endLat endLng:endLng];
    MKMapItem *startMapItem = [mapItems firstObject];
    MKMapItem *endMapItem = [mapItems lastObject];
    
    MKDirections *directions = [Directions getMKDirectionsFromMapItems:startMapItem endMapItem:endMapItem departureDate:departureDate];
    
    [directions calculateDirectionsWithCompletionHandler:completion];
}

+ (void)getETALatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng departureDate:(NSDate *)departureDate withCompletion:(MKETAHandler _Nonnull)completion {
    // initialize placemarks from lat/lng
    NSArray *mapItems = [self getMapItemsWithLatLng:startLat startLng:startLng endLat:endLat endLng:endLng];
    MKMapItem *startMapItem = [mapItems firstObject];
    MKMapItem *endMapItem = [mapItems lastObject];
    
    MKDirections *directions = [Directions getMKDirectionsFromMapItems:startMapItem endMapItem:endMapItem departureDate:departureDate];
    
    [directions calculateETAWithCompletionHandler:completion];
}

+ (NSArray <MKMapItem *> *)getMapItemsWithLatLng:(NSNumber *)startLat startLng:(NSNumber *)startLng endLat:(NSNumber *)endLat endLng:(NSNumber *)endLng {
    // initialize placemarks from lat/lng
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(startLat.doubleValue, startLng.doubleValue);
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate];
    
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake(endLat.doubleValue, endLng.doubleValue);
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate];
    
    MKMapItem *startMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    MKMapItem *endMapItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    return [NSArray arrayWithObjects:startMapItem, endMapItem, nil];
}

+ (NSArray <MKMapItem *> *)getTransportationEventMapItems:(Event *)event {
    // if not a transpo event
    if (![event.category isEqualToString:@"transportation"]) {
        return nil;
    }
    
    return [self getMapItemsWithLatLng:event.latitude startLng:event.longitude endLat:event.endLatitude endLng:event.endLongitude];
}

// TODO: create transportation event between two events
+ (Event *)makeTransportationEventFromEvents:(Event *)startEvent endEvent:(Event *)endEvent withCompletion:(PFBooleanResultBlock)completion {
    // set up title
    NSString *title = [NSString stringWithFormat:@"%@ to %@", startEvent.title, endEvent.title];
    
    // set up description
    NSString *eventDescription = [NSString stringWithFormat:@"The allotted time to travel from %@ (%@) to %@ (%@)", startEvent.title, startEvent.address, endEvent.title, endEvent.address];
    
    // assign locations
    NSString *startAddress = startEvent.address;
    NSNumber *startLatitude = startEvent.latitude;
    NSNumber *startLongitude = startEvent.longitude;
    NSString *endAddress = endEvent.address;
    NSNumber *endLatitude = endEvent.latitude;
    NSNumber *endLongitude = endEvent.longitude;
    
    // set up time
    NSDate *startTime = startEvent.endTime;
    NSDate *endTime = endEvent.startTime;
    
    Event *transportationEvent = [Event initTransportationEvent:title eventDescription:eventDescription startAddress:startAddress startLatitude:startLatitude startLongitude:startLongitude endAddress:endAddress endLatitude:endLatitude endLongitude:endLongitude startTime:startTime endTime:endTime transpoType:@"drive" cost:0 notes:@"" withCompletion:nil];
    
    [Directions getETALatLng:startLatitude startLng:startLongitude endLat:endLatitude endLng:endLongitude departureDate:startTime withCompletion:^(MKETAResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"successfully got ETA");
            
            NSDate *endTime = [NSDate dateWithTimeInterval:response.expectedTravelTime sinceDate:startTime];
            
            // update transportation event by recommended transport type (from maps)
            switch (response.transportType) {
                case MKDirectionsTransportTypeAutomobile:
                    transportationEvent.transpoType = @"drive";
                    break;
                case MKDirectionsTransportTypeWalking:
                    transportationEvent.transpoType = @"walk";
                    break;
                case MKDirectionsTransportTypeTransit:
                    transportationEvent.transpoType = @"transit";
                    break;
                case MKDirectionsTransportTypeAny:
                    transportationEvent.transpoType = @"ride";
                    break;
                default:
                    transportationEvent.transpoType = @"drive";
                    break;
            }
            
            // update transportation type + end time (from ETA response)
            [transportationEvent updateTransportationEventTypeAndTimes:transportationEvent.transpoType startTime:startTime endTime:endTime withCompletion:completion];
        }
        else {
            NSLog(@"error getting ETA: %@", error.domain);
        }
    }];
    
    return transportationEvent;
}

+ (void)openTransportationEventInMaps:(Event *)event {
    // get placemarks for start/end locations, turn into map items
    NSArray <MKMapItem *> *mapItems = [Directions getTransportationEventMapItems:event];
    MKMapItem *startMapItem = [mapItems firstObject];
    MKMapItem *endMapItem = [mapItems lastObject];
    
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
    NSDictionary<NSString *, id> *options = @{MKLaunchOptionsDirectionsModeKey: transportationMode, MKLaunchOptionsShowsTrafficKey:@true};
    [MKMapItem openMapsWithItems:mapItems launchOptions:options];
}

@end
