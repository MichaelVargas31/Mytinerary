//
//  TransportationEventAnnotationView.m
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "TransportationEventAnnotationView.h"
#import "Image.h"

@implementation TransportationEventAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    TransportationEventAnnotationView *transpoEventAnnotationView = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    transpoEventAnnotationView.enabled = YES;
    UIImage *carImage = [UIImage imageNamed:@"teal-car"];
    UIImage *resizedCarImage = [Image imageWithImage:carImage scaledToFillSize:CGSizeMake(35, 35)];
    transpoEventAnnotationView.image = resizedCarImage;

    transpoEventAnnotationView.annotation = annotation;
    transpoEventAnnotationView.canShowCallout = YES;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [transpoEventAnnotationView setRightCalloutAccessoryView:btn];

    return transpoEventAnnotationView;
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
