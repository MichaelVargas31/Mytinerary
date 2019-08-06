//
//  InputProfileViewController.h
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputProfileViewController : UIViewController

@property (strong, nonatomic) NSArray <Itinerary *> *itineraries;

@end

NS_ASSUME_NONNULL_END
