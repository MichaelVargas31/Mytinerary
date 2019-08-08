//
//  InputProfileViewController.h
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputProfileViewController : UIViewController

@property (strong, nonatomic) NSArray <Itinerary *> *itineraries;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (strong, nonatomic) User *profileUser;

@end

NS_ASSUME_NONNULL_END
