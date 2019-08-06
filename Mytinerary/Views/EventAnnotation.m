//
//  EventAnnotation.m
//  Mytinerary
//
//  Created by samason1 on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "EventAnnotation.h"

@implementation EventAnnotation
@synthesize coordinate, title, subtitle;

+ (EventAnnotation *)initAnnotationWithEventForCoordinate:(Event *)event coordinate:(CLLocationCoordinate2D)coordinate {
    EventAnnotation* annotation= [[EventAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = event.title;
    annotation.event = event;
    
    if ([event.category isEqualToString:@"transportation"]) {
        annotation.subtitle = event.transpoType;
    }
    return annotation;
}

//- (MKAnnotationView *)annotationView {
//    // for non-transportation events
//    if (![self.event.category isEqualToString:@"transportation"]) {
//        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Pin"];
//        switch (self.group) {
//            case 1: // food
//                pinView.pinTintColor = UIColor.purpleColor;
//                break;
//            case 2: // activity
//                pinView.pinTintColor = UIColor.yellowColor;
//                break;
//            case 3: // hotel
//                pinView.pinTintColor = UIColor.redColor;
//                break;
//            default: // should never get here
//                pinView.pinTintColor = UIColor.greenColor;
//                break;
//        }
//        pinView.annotation = self;
//        pinView.animatesDrop = YES;
//        pinView.canShowCallout = YES;
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [pinView setRightCalloutAccessoryView:btn];
//        
//        return pinView;
//    }
//    // for transportation events
//    else {
//        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"EventAnnotation"];
//        annotationView.enabled = YES;
//        UIImage *carImage = [UIImage imageNamed:@"teal-car"];
//        UIImage *resizedCarImage = [self imageWithImage:carImage scaledToFillSize:CGSizeMake(35, 35)];
//        annotationView.image = resizedCarImage;
//        
//        annotationView.annotation = self;
////        annotationView.animatesDrop = YES;
//        annotationView.canShowCallout = YES;
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [annotationView setRightCalloutAccessoryView:btn];
//        
//        return annotationView;
//    }
//} 

//- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size {
//    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
//    CGFloat width = image.size.width * scale;
//    CGFloat height = image.size.height * scale;
//    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
//                                  (size.height - height)/2.0f,
//                                  width,
//                                  height);
//    
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    [image drawInRect:imageRect];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

@end
