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
#import "Colors.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation, EventDetailsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray <Event *> *routePolylineEvents; // parallel with mapkit's polyline overlays (representing transportation events)
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation MapViewController

@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up alert controller
    self.alert = [UIAlertController alertControllerWithTitle:@"Map Message"
                                                     message:@"This is an alert."
                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [self.alert addAction:defaultAction];
    
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:false];
    
    [self sideMenus];
    
    // initialize empty mutable array
    self.routePolylineEvents = [[NSMutableArray alloc] init];
    
    // set up itinerary
    UIButton *button = [[UIButton alloc] init];
    [button setAccessibilityFrame:CGRectMake(0, 0, 100, 40)];
    [button setTitle:self.itinerary.title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.0f weight:UIFontWeightBold]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapItineraryTitle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    // get itinerary events
    self.events = [NSMutableArray arrayWithArray:self.itinerary.events];
    if (self.events.count == 0) {
        self.alert.message = @"No events to display";
        [self presentViewController:self.alert animated:YES completion:nil];
    }
    
    [Event fetchAllIfNeededInBackground:self.events block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            NSLog(@"successfully loaded events from '%@'", self.itinerary.title);
            self.events = [NSMutableArray arrayWithArray:objects];
            [self makeEventAnnotations];
        }
        else {
            NSLog(@"error loading events from '%@': %@", self.itinerary.title, error);
        }
    }];
    
    // setup custom annotation view
    [self.mapView registerClass:[TransportationEventAnnotationView class] forAnnotationViewWithReuseIdentifier:@"TransportationEventAnnotationView"];
}


-(void)sideMenus{
    
    if(self.revealViewController != nil){
        self.mapMenuBtn.target = self.revealViewController;
        self.mapMenuBtn.action = @selector(revealToggle:);
        self.revealViewController.rearViewRevealWidth = 275;
        self.revealViewController.rightViewRevealWidth = 160;
        
     
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
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
                        pinView.pinTintColor = [Colors redColor];
                        break;
                    case 2: // activity
                        pinView.pinTintColor = [Colors goldColor];
                        break;
                    case 3: // hotel
                        pinView.pinTintColor = [Colors blueColor];
                        break;
                    default: // should never get here
                        pinView.pinTintColor = [Colors goldColor];
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

      //goes back to daily calendar
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
        [renderer setStrokeColor:[Colors periwinkleColor]];
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
        eventDetailsViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"mapToItineraryDetailsSegue"]) {
        ItineraryDetailsViewController *itineraryDetailsViewController = [segue destinationViewController];
        itineraryDetailsViewController.itinerary = self.itinerary;
    }
}

- (void)didDeleteEvent:(nonnull Event *)deletedEvent {
    // get rid of it in parse (update the itinerary object)
    [Event deleteEvent:deletedEvent itinerary:self.itinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully deleted '%@'", deletedEvent.title);
        }
        else {
            NSLog(@"error deleting '%@': %@", deletedEvent.title, error.domain);
        }
    }];
    
    [self didUpdateEvent:deletedEvent];
}

- (void)didUpdateEvent:(nonnull Event *)updatedEvent {
    [self.events removeObject:updatedEvent];
    
    // if transportation object, remove route polyline overlays + corresponding events
    if ([updatedEvent.category isEqualToString:@"transportation"]) {
        NSInteger updatedEventIdx = [self.routePolylineEvents indexOfObject:updatedEvent];
        [self.routePolylineEvents removeObject:updatedEvent];
        [self.mapView removeOverlay:self.mapView.overlays[updatedEventIdx]];
    }
    
    // remove from all annotations
    NSArray <EventAnnotation *> *mapAnnotations = self.mapView.annotations;
    NSInteger updatedEventIdx = [mapAnnotations indexOfObjectPassingTest:^BOOL(EventAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.event.objectId isEqualToString:updatedEvent.objectId];
    }];
    [self.mapView removeAnnotation:self.mapView.annotations[updatedEventIdx]];
    
    [self viewDidLoad];
}

@end
