//
//  ItineraryDetailsViewController.h
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ItineraryDetailsViewControllerDelegate

- (void)didDeleteItinerary;

@end


@interface ItineraryDetailsViewController : UIViewController

@property (strong, nonatomic) Itinerary *itinerary;
@property (weak, nonatomic) id<ItineraryDetailsViewControllerDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
