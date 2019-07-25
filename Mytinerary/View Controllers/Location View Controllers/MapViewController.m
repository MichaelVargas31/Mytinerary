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


@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Location *lolo;
@property (nonatomic, strong) NSArray * events;
//@property NSMutableArray *coordinatesArray;
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
    
    
    
    
    //[self loadCoordinatesFromParse];
     MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    PFQuery *q = [Event query];
    [q orderByDescending:@"name"];
    [q includeKey:@"address"];
    q.limit = 20;
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *  eArray, NSError *  error) {
        if (!error) {
            NSLog(@"  recieved:  %@", eArray);
            self.events = eArray;
            NSLog(@"  new array:  %@", self.events);
            for(int i =0; i< self.events.count; i++){
                Event *e = self.events[i];
                NSNumber *la = e.latitude;
                NSNumber *lon = e.longitude;
                NSString *n = e.title;
                CGFloat l = [la doubleValue];
                CGFloat lg = [lon doubleValue];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(l,lg);

                [annotation setCoordinate:coord];
                [annotation setTitle:n];
                [self.mapView addAnnotation:annotation];

            }
        }}];
    
    
   /* NSNumber *la =  self.event.latitude;
    NSNumber *lon = self.event.longitude;
    NSLog(@"Is getting here ");
    CGFloat l = [la myCGFloatValue];
    CGFloat lg = [lon myCGFloatValue];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(0.5,0.5);
    CLLocationCoordinate2D coordinate;
    [annotation setCoordinate:coord];
    NSLog(@"Coordinates together%@", la);
    [annotation setTitle:self.event.title]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    //[self.mapView showAnnotations:annotation animated:YES];*/

  }

//locationManager delegate method
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    MKCoordinateRegion mapRegion;
   mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
    [self.mapView setRegion:mapRegion animated: YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ){
      //pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation]];
       //must fix this
        
        
        NSLog(@"PIN"); //Is gettig here WOOHOO
        if (annotation) {
            MKPinAnnotationView *neutralPinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"neutral"];
            if(!neutralPinView){
                neutralPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"neutral"];
            }

        //[self.mapView selectAnnotation:pinView animated:YES];
    pinView.pinColor = MKPinAnnotationColorPurple;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = infoButton;
    //[defaultPinID release];
    }
    
}
    return pinView;
}
/*
-(void) loadCoordinatesFromParse {
    NSDictionary * parseData;
    //load parseData from Parse here
    PFQuery *q = [Event query];
    [q orderByDescending:@"name"];
    [q includeKey:@"address"];
    q.limit = 20;
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *  coordinatesArray, NSError *  error) {
        if (!error) {
            NSLog(@"  recieved:  %@", coordinatesArray);
            self.locations = coordinatesArray;
            NSLog(@"  new array:  %@", self.locations);

        }}];
    
    NSMutableArray * coordinates = [NSMutableArray array];
    
       //parseData *location = [Event initWithDictionary:dict];
       // [locations addObject:location];


    NSLog(@"parse data%@", parseData);
    NSArray * latitudes = [parseData objectForKey:@"latitude"];
    
    NSArray *longitudes = [parseData objectForKey:@"longitude"];
    
    for (int i = 0; i < [latitudes count]; i++) {
        double latitude = [latitudes[i] doubleValue];
        double longitude = [longitudes[i] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        [coordinates addObject: [NSValue valueWithMKCoordinate:coordinate]];
    }
    
    NSLog(@"coordinates array = %@", coordinates);
    self.locations = [NSArray arrayWithArray: coordinates];
}*/
   
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id             <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"identifier";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
    {
        NSLog(@"Inside IF");
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.pinColor = MKPinAnnotationColorRed;  //or Green or Purple
        
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //Accessoryview for the annotation view in ios.
        pinView.rightCalloutAccessoryView = btn;
    }
    else
    {
        pinView.annotation = annotation;
    }
    
    return pinView;
}*/
/*
NSNumber *la =  self.event.latitude;
NSNumber *lon = self.event.longitude;

NSNumber *n = self.event.latitude;
CGFloat f = [n myCGFloatValue];*/


-(CGFloat)myCGFloatValue{
    CGFloat result;
    CFNumberGetValue((__bridge CFNumberRef)(self), kCFNumberCGFloatType, &result);
    return result;
}


/*
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
            NSLog(@"Events: %@", self.eArray);
            
            
            //pin location onto map maybe
        }
        else{
            //handle error
        }
    }];
    
    
}*/

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
