//
//  User.m
//  Mytinerary
//
//  Created by ehhong on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username;
@synthesize password;
@synthesize defaultItinerary;

+ (User *)initUserWithPFUser:(PFUser *)PFUser {
    User *user = [[User alloc] init];
    user.username = PFUser[@"username"];
    user.defaultItinerary = PFUser[@"defaultItinerary"];
    return user;
}

+ (void)registerUser:(NSString *)username password:(NSString *)password withCompletion:(PFBooleanResultBlock)completion {
    // initialize a user object
    PFUser *user = [PFUser user];
    
    // set user properties
    user.username = @"testtest";
    user.password = password;
    
//    [user signUpInBackgroundWithBlock:completion];
    [user signUp];
}

+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(PFUserResultBlock)completion {
    [PFUser logInWithUsernameInBackground:username password:password block:completion];
}

+ (void)logoutUser:(PFUserLogoutResultBlock)completion {
    [PFUser logOutInBackgroundWithBlock:completion];
}

+ (void)resetDefaultItinerary:(PFUser *)user itinerary:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion {
    user[@"defaultItinerary"] = itinerary;
    [user saveInBackgroundWithBlock:completion];
}

@end
