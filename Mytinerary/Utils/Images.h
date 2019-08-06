//
//  Images.h
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit"

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSObject

// resizes image based on given dimensions
+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
