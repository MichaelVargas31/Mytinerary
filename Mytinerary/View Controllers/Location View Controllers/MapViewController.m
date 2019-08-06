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
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "Location.h"
#import "Event.h"
#import "Directions.h"
#import "SWRevealViewController.h"
#import "EventDetailsViewController.h"

#import "MyAnnotation.h"

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
    
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
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

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation {
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    }
    
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        MyAnnotation *myAnn = (MyAnnotation *)annotation;
        switch (myAnn.group)
        {
            case 1: // food
                pinView.pinTintColor = UIColor.purpleColor;
                break;
            case 2: // activity
                pinView.pinTintColor = UIColor.yellowColor;
                break;
            case 3: // hotel
                pinView.pinTintColor = UIColor.redColor;
                break;
            default: // transportation -- eventually change to custom annotation
                pinView.pinTintColor = UIColor.greenColor;
                break;
        }
    }

    pinView.annotation = annotation;
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [pinView setRightCalloutAccessoryView:btn];
  
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // get event associated with annotation view
    MyAnnotation *annotation = view.annotation;
    Event *event = annotation.event;
    
    // segue to event details view
    [self performSegueWithIdentifier:@"mapToEventDetailsSegue" sender:event];
}

- (IBAction)onTapCalendarButton:(id)sender {
    [self performSegueWithIdentifier:@"mapToCalendarSegue" sender:nil];
}

- (void)onTapItineraryTitle {
    // TODO -- wait for shandler to finish segues
    NSLog(@"tapped itinerary title!");
}

#pragma mark - Transportation/directions stuff

// get the route from a given transportation event
- (void)getTransportationEventRoute:(Event *)event {
    [Directions getDirectionsLatLng:event.latitude startLng:event.longitude endLat:event.endLatitude endLng:event.endLongitude departureDate:event.startTime withCompletion:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"successfully got directions for '%@'", event.title);
            MKRoute *route = response.routes[0];
            
            // keep corresponding transpo events parallel with overlays
            [self showDirection:route transpoEvent:event];
            [self.routePolylineEvents addObject:event];
            
            [self updateTransportationEvent:event route:route];
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
    [self createAndAddAnnotationForCoordinate:MKCoordinateForMapPoint(middlePoint) transpoEvent:transpoEvent];
}

-(void)createAndAddAnnotationForCoordinate:(CLLocationCoordinate2D)coordinate transpoEvent:(Event *)transpoEvent {
    MyAnnotation* annotation= [[MyAnnotation alloc] init];
    annotation.coordinate = coordinate;

    annotation.title = transpoEvent.title;
    annotation.subtitle = transpoEvent.transpoType;
    annotation.event = transpoEvent;

    [self.mapView addAnnotation:annotation];
}

- (void)updateTransportationEvent:(Event *)event route:(MKRoute *)route {
    NSTimeInterval timeElapsed = route.expectedTravelTime;
    NSDate *updatedEndTime = [NSDate dateWithTimeInterval:timeElapsed sinceDate:event.startTime];
    
    NSString *transpoType = [[NSString alloc] init];
    switch (route.transportType) {
        case MKDirectionsTransportTypeWalking:
            transpoType = @"walk";
            break;
        case MKDirectionsTransportTypeTransit:
            transpoType = @"transit";
            break;
        case MKDirectionsTransportTypeAutomobile:
            transpoType = @"drive";
            break;
        case MKDirectionsTransportTypeAny:
            transpoType = @"ride";
            break;
        default:
            transpoType = @"other";
            break;
    }
    
    [event updateTransportationEventTypeAndTimes:transpoType startTime:event.startTime endTime:updatedEndTime withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"transportation times/type successfully updated");
        }
        else {
            NSLog(@"error updating transpo event times/type: %@", error);
        }
    }];
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
}


@end
