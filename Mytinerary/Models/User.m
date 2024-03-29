//
//  User.m
//  Mytinerary
//
//  Created by ehhong on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize defaultItinerary;

+ (User *)makeUserWithPFUser:(PFUser *)PFUser {
    User *user = [User user];
    user.username = PFUser[@"username"];
    user.defaultItinerary = PFUser[@"defaultItinerary"];
    return user;
}

+ (nullable instancetype)currentUser {
    User *user = [super currentUser];
    user.defaultItinerary = user[@"defaultItinerary"];
    
    return user;
}

+ (void)signUpUser:(NSString *)username password:(NSString *)password withCompletion:(PFBooleanResultBlock)completion {
    // initialize a user object
    User *user = [User user];
    
    // set user properties
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:completion];
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

- (void)updateUser:(NSString *)username password:(NSString *)password defaultItinerary:(Itinerary *)defaultItinerary withCompletion:(PFBooleanResultBlock)completion {
    if (![username isEqualToString:@""]) {
        self.username = username;
    }
    if (![password isEqualToString:@""]) {
        self.password = password;
    }
    [User resetDefaultItinerary:self itinerary:defaultItinerary withCompletion:completion];
}

-(void)profilePicture: (PFFileObject *) pP withCompletion:(PFBooleanResultBlock)completion{
    if (pP) {
        self.profilePicture=pP;
    }
}

@end
