//
//  ProfileCollectionReusableView.m
//  Mytinerary
//
//  Created by michaelvargas on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ProfileCollectionReusableView.h"


@implementation ProfileCollectionReusableView



-(void)addProfilePicImageView:(User *)user{
[user.profilePicture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        [self.profilePicImageView setImage:image];
    } else {
        NSLog(@"error getting image data: %@", error.localizedDescription);
    }
}];}

@end
