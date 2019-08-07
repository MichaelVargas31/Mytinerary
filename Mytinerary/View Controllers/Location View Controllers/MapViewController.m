//
//  MapViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "DailyCalendarViewController.h"
#import "ItineraryDetailsViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "Location.h"
#import "Event.h"
#import "Directions.h"
#import "SWRevealViewController.h"
#import "EventDetailsViewController.h"

#import "EventAnnotation.h"
#import "TransportationEventAnnotationView.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>

@property (strong, nonatomic) Event *event;
@property (nonatomic, strong) NSArray *events;
@property (strong, nonatomic) NSMutableArray <Event *> *routePolylineEvents; // parallel with mapkit's polyline overlays (representing transportation events)

@end

@implementation MapViewController

@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:false];
    
    // initialize empty mutable array
    self.routePolylineEvents = [[NSMutableArray alloc] init];
    
    // set up itinerary
    UIButton *button = [[UIButton alloc] init];
    [button setAccessibilityFrame:CGRectMake(0, 0, 100, 40)];
    [button setTitle:self.itinerary.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapItineraryTitle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    // get itinerary events
    self.events = self.itinerary.events;
    [Event fetchAllIfNeededInBackground:self.events block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            NSLog(@"successfully loaded events from '%@'", self.itinerary.title);
            self.events = objects;
            [self makeEventAnnotations];
        }
        else {
            NSLog(@"error loading events from '%@': %@", self.itinerary.title, error);
        }
    }];
    
    // setup custom annotation view
    [self.mapView registerClass:[TransportationEventAnnotationView class] forAnnotationViewWithReuseIdentifier:@"TransportationEventAnnotationView"];
}

- (void)makeEventAnnotations {
    // make annotations for events
    for (int i = 0; i < self.events.count; i++) {
        Event *event = self.events[i];
        [self makeAnnotationFromEvent:event];
    }
    
    if (self.events.count > 0) {
        // set region of map to around first event
        Event *firstEvent = self.events[0];
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(firstEvent.latitude.floatValue, firstEvent.longitude.floatValue), MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:false];
    }
}

// make annotation for individual event
- (void)makeAnnotationFromEvent:(Event *)event {
    NSString *category = event.category;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(event.latitude.floatValue, event.longitude.floatValue);
    
    EventAnnotation *annotation = [[EventAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [annotation setTitle:event.title];
    [annotation setEvent:event];
    
    if ([category isEqualToString:@"food"]) {
        annotation.group = 1;
        [self.mapView addAnnotation:annotation];
    }
    else if ([category isEqualToString:@"activity"]) {
        annotation.group = 2;
        [self.mapView addAnnotation:annotation];
    }
    else if ([category isEqualToString:@"hotel"]) {
        annotation.group = 3;
        [self.mapView addAnnotation:annotation];
    }
    else if ([category isEqualToString:@"transportation"]) {
        annotation.group = 4;
        // get route polyline
        [self getTransportationEventRoute:event];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
        if ([annotation isKindOfClass:[EventAnnotation class]]) {
            EventAnnotation *eventAnnotation = (EventAnnotation *)annotation;
            
            // use pin annotation view for non-transportation events
            if (![eventAnnotation.event.category isEqualToString:@"transportation"]) {
                MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
                
                // if nothing to dequeue, init new pin annotation view
                if (pinView == nil) {
                    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
                }
                else {
                    pinView.annotation = eventAnnotation;
                }
                switch (eventAnnotation.group) {
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
            // custom annotation for transportation events
            else {
                TransportationEventAnnotationView *transpoAnnotationView = (TransportationEventAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"TransportationEventAnnotationView"];
                if (transpoAnnotationView == nil) {
                    transpoAnnotationView = [transpoAnnotationView initWithAnnotation:eventAnnotation reuseIdentifier:@"TransportationEventAnnotationView"];
                }
                else {
                    transpoAnnotationView.annotation = eventAnnotation;
                }
                
                [transpoAnnotationView assignTranspoImage:eventAnnotation];
                return transpoAnnotationView;
            }
        }
        return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // get event associated with annotation view
    EventAnnotation *annotation = view.annotation;
    Event *event = annotation.event;
    
    // segue to event details view
    [self performSegueWithIdentifier:@"mapToEventDetailsSegue" sender:event];
}

- (IBAction)onTapCalendarButton:(id)sender {
    [self performSegueWithIdentifier:@"mapToCalendarSegue" sender:nil];
}

- (void)onTapItineraryTitle {
    [self performSegueWithIdentifier:@"mapToItineraryDetailsSegue" sender:nil];
}

#pragma mark - Transportation/directions stuff

// get the route from a given transportation event
- (void)getTransportationEventRoute:(Event *)event {
    // routes not supported for transit, substitute with route for drive
    NSString *transpoType = event.transpoType;
    if ([event.transpoType isEqualToString:@"transit"]) {
        transpoType = @"drive";
    }
    [Directions getDirectionsLatLng:event.latitude startLng:event.longitude endLat:event.endLatitude endLng:event.endLongitude departureDate:event.startTime transpoType:transpoType withCompletion:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"successfully got directions for '%@'", event.title);
            MKRoute *route = response.routes[0];
            
            // keep corresponding transpo events parallel with overlays
            [self showDirection:route transpoEvent:event];
            [self.routePolylineEvents addObject:event];
        }
        else {
            NSLog(@"error getting directions for '%@': %@", event.title, error);
        }
    }];
}

- (void)showDirection:(MKRoute *)route transpoEvent:(Event *)transpoEvent {
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    
    // add annotation to middle of route
    MKMapPoint middlePoint = route.polyline.points[route.polyline.pointCount/2];
    EventAnnotation *annotation = [EventAnnotation initAnnotationWithEventForCoordinate:transpoEvent coordinate:MKCoordinateForMapPoint(middlePoint)];
    [self.mapView addAnnotation:annotation];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setLineWidth:4.0];
        [renderer setStrokeColor:[UIColor blueColor]];
        return renderer;
    }
    return nil;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mapToCalendarSegue"]) {
        SWRevealViewController *revealViewController = [segue destinationViewController];
        revealViewController.itinerary = self.itinerary;
    }
    else if ([[segue identifier] isEqualToString:@"mapToEventDetailsSegue"]) {
        Event *event = sender;
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.event = event;
    }
    else if ([[segue identifier] isEqualToString:@"mapToItineraryDetailsSegue"]) {
        ItineraryDetailsViewController *itineraryDetailsViewController = [segue destinationViewController];
        itineraryDetailsViewController.itinerary = self.itinerary;
    }
}

@end
