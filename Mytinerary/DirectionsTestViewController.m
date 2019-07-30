//
//  DirectionsTestViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/30/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DirectionsTestViewController.h"
#import "Directions.h"
#import "Event.h"

@interface DirectionsTestViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKRoute *route;

@end

@implementation DirectionsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.7749, -122.4194), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:region animated:false];
    
    // make test transportation object
    NSDate *startTime = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    
    Event *event = [Event initTransportationEvent:@"test transpo" eventDescription:@"testing my directions feature" startAddress:@"151 3rd St, San Francisco, CA 94103" startLatitude:@(37.7780603) startLongitude:@(-122.4211881) endAddress:@"Lombard St, San Francisco, CA 94133" endLatitude:@(37.7872584) endLongitude:@(-122.428875) startTime:startTime endTime:endTime transpoType:@"test" cost:0.0 notes:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"transpo test created");
        }
        else {
            NSLog(@"error transpo test event: %@", error);
        }
    }];
    
    [Directions getDirectionsLatLng:event.latitude startLng:event.longitude endLat:event.endLatitude endLng:event.endLongitude withCompletion:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"successfully got directions");
            self.route = response.routes[0];
            [self showDirection:self.route];
            [self updateTransportationEvent:event route:self.route];
        }
        else {
            NSLog(@"error getting directions: %@", error);
        }
    }];
    
    [self showStartEndLocations:event];
}

- (void)showStartEndLocations:(Event *)event {
    MKPointAnnotation *startPoint = [[MKPointAnnotation alloc] init];
    [startPoint setCoordinate:CLLocationCoordinate2DMake(event.latitude.doubleValue, event.longitude.doubleValue)];
    MKPointAnnotation *endPoint = [[MKPointAnnotation alloc] init];
    [endPoint setCoordinate:CLLocationCoordinate2DMake(event.endLatitude.doubleValue, event.endLongitude.doubleValue)];
    
    [self.mapView addAnnotations:[NSArray arrayWithObjects:startPoint, endPoint, nil]];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    return pinView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    [renderer setLineWidth:4.0];
    [renderer setStrokeColor:[UIColor blueColor]];
    
    return renderer;
}

//func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//    let renderer = MKPolylineRenderer(overlay: overlay)
//    renderer.strokeColor = UIColor.redColor()
//    renderer.lineWidth = 4.0
//
//    return renderer
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
