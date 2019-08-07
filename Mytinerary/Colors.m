//
//  Colors.m
//  Mytinerary
//
//  Created by ehhong on 8/7/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "Colors.h"
#import <UIKit/UIKit.h>

@implementation Colors

+ (UIColor *)goldColor {
    return [Colors colorWithHue:32 saturation:67 brightness:99 alpha:1];
}

+ (UIColor *)darkGoldColor {
    return [Colors colorWithHue:32 saturation:67 brightness:79 alpha:1];
}

+ (UIColor *)redColor {
    return [Colors colorWithHue:357 saturation:59 brightness:79 alpha:1];
}

+ (UIColor *)darkRedColor {
    return [Colors colorWithHue:357 saturation:59 brightness:59 alpha:1];
}

+ (UIColor *)purpleColor {
    return [Colors colorWithHue:332 saturation:22 brightness:68 alpha:1];
}

+ (UIColor *)darkPurpleColor {
    return [Colors colorWithHue:332 saturation:22 brightness:48 alpha:1];
}

+ (UIColor *)periwinkleColor {
    return [Colors colorWithHue:230 saturation:44 brightness:76 alpha:1];
}

+ (UIColor *)lightBlueColor {
    return [Colors colorWithHue:225 saturation:50 brightness:100 alpha:1];
}

+ (UIColor *)darkLightBlueColor {
    return [Colors colorWithHue:225 saturation:50 brightness:70 alpha:1];
}

+ (UIColor *)blueColor {
    return [Colors colorWithHue:225 saturation:67 brightness:86 alpha:1];
}

+ (UIColor *)darkBlueColor {
    return [Colors colorWithHue:225 saturation:67 brightness:56 alpha:1];
}

// converts values from out of 360:100:100:1 --> 1:1:1:1
+ (UIColor *)colorWithHue:(int)hue saturation:(int)saturation brightness:(int)brightness alpha:(int)alpha {
    return [UIColor colorWithHue:hue/360.0 saturation:saturation/100.0 brightness:brightness/100.0 alpha:alpha/1.0];
}

@end
