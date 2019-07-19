//
//  MapViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "Event.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager.requestAlwaysAuthorization;
    self.locationManager.requestWhenInUseAuthorization;
   
    if(CLLocationManager.locationServicesEnabled){
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.startUpdatingLocation;
    }
    
    self.mapView.delegate=self;
    [self querySearch];

  }

//locationManager delegate method
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    MKCoordinateRegion mapRegion;
   mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
    [self.mapView setRegion:mapRegion animated: YES];
}

//gets the addresses of the event
-(void) querySearch{
    PFQuery *eQuery = [Event query];
    [eQuery orderByDescending: @"createdAt"];
    [eQuery includeKey:@"address"];
   
    eQuery.limit =10;
    
    //fetch data
    [eQuery findObjectsInBackgroundWithBlock:^(NSArray<Event *> * event, NSError *  error) {
        if(event){
            self.eArray = event;
            NSLog(@"%@", self.eArray);
            
            
            //pin location onto map maybe
        }
        else{
            //handle error
        }
    }];
    
    
}

/* Set visible region to San Francisco when opening the map
 MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
 [self.mapView setRegion:sfRegion animated:false];
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
