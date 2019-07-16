//
//  User.m
//  Mytinerary
//
//  Created by ehhong on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "User.h"
#import "Itinerary.h"

@implementation User

+ (void)registerUser:(NSString *)username password:(NSString *)password withCompletion:(PFBooleanResultBlock)completion {
    // initialize a user object
    PFUser *user = [PFUser user];
    
    // set user properties
    user.username = username;
    user.password = password;
    user[@"defaultItinerary"] = [[Itinerary alloc] init];
    
    [user signUpInBackgroundWithBlock:completion];
}

+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(PFUserResultBlock)completion {
    [PFUser logInWithUsernameInBackground:username password:password block:completion];
}

+ (void)resetDefaultItinerary:(PFUser *)user itinerary:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion {
    user[@"defaultItinerary"] = itinerary;
    [user saveInBackgroundWithBlock:completion];
}

@end
