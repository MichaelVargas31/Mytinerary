//
//  ProfileViewController.h
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) NSArray *iArray;
@property (strong, nonatomic) NSArray *itineraryImageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *mB;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *aB;
@property (weak, nonatomic) IBOutlet UIImageView *pPic;

@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
