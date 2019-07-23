//
//  EventDetailsViewController.h
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventDetailsViewController : UIViewController

@property (strong, nonatomic) Event *event;

@end

NS_ASSUME_NONNULL_END
