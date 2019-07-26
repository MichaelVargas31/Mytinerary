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
#import "Location.h"

#import "MyAnnotation.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Location *lolo;
@property (nonatomic, strong) NSArray * events;

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
    
    PFQuery *q = [Event query];
    [q orderByAscending:@"createdAt"];
    [q includeKey:@"address"];
    q.limit = 50;
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *  eArray, NSError *  error) {
        if (!error) {
            self.events = eArray;
            for(int i =0; i< self.events.count; i++){
                Event *e = self.events[i];
                NSNumber *la = e.latitude;
                NSNumber *lon = e.longitude;
                NSString *n = e.title;
                NSString *ne = e.category;
                CGFloat l = [la doubleValue];
                CGFloat lg = [lon doubleValue];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(l,lg);
                
                MyAnnotation *annotation =[[MyAnnotation alloc] init];
                [annotation setCoordinate:coord];
                [annotation setTitle:n];
                
                if([ne  isEqual: @"food"]){
                    annotation.grupo = 1;
                }else if([ne  isEqual: @"activity"]){
                    annotation.grupo = 2;
                }else if([ne  isEqual: @"hotel"]){
                    annotation.grupo = 3;
                }else{
                    annotation.grupo = 4;
                }
                
                [self.mapView addAnnotation:annotation];
              
                //spans to event pin most recently created
               MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(l, lg), MKCoordinateSpanMake(0.1, 0.1));
               [self.mapView setRegion:region animated:false];
                
            }
        }
    }];
  }

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        
    }
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        MyAnnotation *myAnn = (MyAnnotation *)annotation;
        switch (myAnn.grupo)
        {
            case 1: //food
                pinView.pinTintColor=UIColor.purpleColor;
                break;
            case 2: //activity
                pinView.pinTintColor=UIColor.yellowColor;
                break;
            case 3: //hotel
                pinView.pinTintColor=UIColor.redColor;
                break;
            case 4: //transportation
                pinView.pinTintColor=UIColor.greenColor;
                break;
            default:
                pinView.pinTintColor=UIColor.cyanColor;
                break;
        }
    }

    pinView.annotation=annotation;
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
  
    return pinView;
}


-(CGFloat)myCGFloatValue{
    CGFloat result;
    CFNumberGetValue((__bridge CFNumberRef)(self), kCFNumberCGFloatType, &result);
    return result;
}


/* Set visible region to San Francisco when opening the map
 MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
 [self.mapView setRegion:sfRegion animated:false];
 */

/*
 //locationManager delegate method
 -(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
 MKCoordinateRegion mapRegion;
 mapRegion.center = self.mapView.userLocation.coordinate;
 mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
 [self.mapView setRegion:mapRegion animated: YES];
 
 
 }
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
