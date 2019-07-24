//
//  InputEventViewController.h
//  Mytinerary
//
//  Created by ehhong on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputEventViewController : UIViewController

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Itinerary *itinerary;

@end

NS_ASSUME_NONNULL_END
