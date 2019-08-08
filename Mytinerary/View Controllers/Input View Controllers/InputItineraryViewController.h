//
//  InputItineraryViewController.h
//  Mytinerary
//
//  Created by ehhong on 7/17/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InputItineraryViewControllerDelegate <NSObject>

- (void) didSaveItinerary;

@end

@interface InputItineraryViewController : UIViewController

@property (weak, nonatomic) id<InputItineraryViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *a;

@property (strong, nonatomic) Itinerary *itinerary;


@end

NS_ASSUME_NONNULL_END
