//
//  EventAnnotationView.m
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "TranspoEventAnnotationView.h"
#import "EventAnnotation.h"

@implementation TranspoEventAnnotationView

- (void)prepareForReuse {
}

+ (instancetype)initWithEventAnnotation:(EventAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
//    EventAnnotationView *annotationView = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    TranspoEventAnnotationView *annotationView = (TranspoEventAnnotationView *)[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ([reuseIdentifier isEqualToString:@"Pin"]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)annotationView;
        switch (annotation.group) {
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
        pinView.annotation = annotation;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [pinView setRightCalloutAccessoryView:btn];
        
        return (TranspoEventAnnotationView *)pinView;
    }
    // for transportation events
    else {
        annotationView.enabled = YES;
        UIImage *carImage = [UIImage imageNamed:@"teal-car"];
        UIImage *resizedCarImage = [TranspoEventAnnotationView imageWithImage:carImage scaledToFillSize:CGSizeMake(35, 35)];
        annotationView.image = resizedCarImage;
        
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [annotationView setRightCalloutAccessoryView:btn];
        
        return annotationView;
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size {
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
