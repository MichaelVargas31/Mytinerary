//
//  Image.h
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSObject

+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
