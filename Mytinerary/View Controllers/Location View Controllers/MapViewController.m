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

#import "MyAnnotation.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>

@property (strong, nonatomic) Event *event;
@property (nonatomic, strong) NSArray *events;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:false];
    
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
    
    if ([category isEqualToString:@"food"]) {
        annotation.group = 1;
    }
    else if ([category isEqualToString:@"activity"]) {
        annotation.group = 2;
    }
    else if ([category isEqualToString:@"hotel"]) {
        annotation.group = 3;
    }
    else if ([category isEqualToString:@"transportation"]) {
        annotation.group = 4;
        
        // make annotation from end location
        MyAnnotation *endAnnotation = [[MyAnnotation alloc] init];
        CLLocationCoordinate2D endCoord = CLLocationCoordinate2DMake(event.endLatitude.floatValue, event.endLongitude.floatValue);
        [endAnnotation setCoordinate:endCoord];
        [endAnnotation setTitle:event.title];
        [self.mapView addAnnotation:endAnnotation];
        
        // get route polyline
        [self getTransportationEventRoute:event];
    }
    
    [self.mapView addAnnotation:annotation];
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
            case 4: // transportation
                pinView.pinTintColor = UIColor.greenColor;
                break;
            default:
                pinView.pinTintColor = UIColor.cyanColor;
                break;
        }
    }

    pinView.annotation = annotation;
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
  
    return pinView;
}

- (IBAction)onTapCalendarButton:(id)sender {
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItineraryNavigationController"];
    
    DailyCalendarViewController *dailyCalendarViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyCalendarViewController"];
    
    // pass itinerary from map to daily calendar
    dailyCalendarViewController.itinerary = self.itinerary;
    
    [navigationController setViewControllers:[NSArray arrayWithObject:dailyCalendarViewController]];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onTapItineraryTitle {
    // TODO -- wait for shandler to finish segues
    NSLog(@"tapped itinerary title!");
}

#pragma mark - Transportation/directions stuff

// get the route from a given transportation event
- (void)getTransportationEventRoute:(Event *)event {
    [Directions getDirectionsLatLng:event.latitude startLng:event.longitude endLat:event.endLatitude endLng:event.endLongitude withCompletion:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"successfully got directions for '%@'", event.title);
            MKRoute *route = response.routes[0];
            [self showDirection:route];
            [self updateTransportationEvent:event route:route];
        }
        else {
            NSLog(@"error getting directions for '%@': %@", event.title, error);
        }
    }];
}

- (void)showDirection:(MKRoute *)route {
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
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
            transpoType = @"public transportation";
            break;
        case MKDirectionsTransportTypeAutomobile:
            transpoType = @"car";
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
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    [renderer setLineWidth:4.0];
    [renderer setStrokeColor:[UIColor blueColor]];
    
    return renderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@synthesize coordinate;

@end
