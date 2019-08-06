//
//  TransportationEventAnnotationView.m
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "TransportationEventAnnotationView.h"
#import "EventAnnotation.h"
#import "Image.h"

@implementation TransportationEventAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    EventAnnotation *eventAnnotation = annotation;
    
    [self assignTranspoImage:eventAnnotation];

    self.annotation = annotation;
    self.canShowCallout = YES;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [self setRightCalloutAccessoryView:btn];

    return self;
}

- (void)assignTranspoImage:(EventAnnotation *)eventAnnotation {
    UIImage *image = [[UIImage alloc] init];
    if ([eventAnnotation.event.transpoType isEqualToString:@"drive"]) {
        image = [UIImage imageNamed:@"teal-car"];
    }
    else if ([eventAnnotation.event.transpoType isEqualToString:@"walk"]) {
        image = [UIImage imageNamed:@"walking"];
    }
    UIImage *resizedImage = [Image imageWithImage:image scaledToFillSize:CGSizeMake(35, 35)];
    self.image = resizedImage;
}

@end
