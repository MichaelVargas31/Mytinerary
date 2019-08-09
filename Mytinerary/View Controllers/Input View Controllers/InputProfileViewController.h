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

@protocol InputProfileViewControllerDelegate <NSObject>

- (void) didSaveProfilePicture;

@end


@interface InputProfileViewController : UIViewController
@property (weak, nonatomic) id<InputProfileViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray <Itinerary *> *itineraries;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (strong, nonatomic) User *profileUser;

@end

NS_ASSUME_NONNULL_END
