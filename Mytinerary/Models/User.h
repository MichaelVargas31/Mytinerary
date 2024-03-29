//  User.h

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Itinerary.h"

@interface User : PFUser

@property (nonatomic, strong) Itinerary *defaultItinerary;
@property (nonatomic, strong) PFFileObject *profilePicture;

+ (User *)makeUserWithPFUser:(PFUser *)user;

+ (nullable instancetype)currentUser;

+ (void)signUpUser:(NSString *)username password:(NSString *)password withCompletion:(PFBooleanResultBlock)completion;

// example usage of registerUser
/* [User registerUser:@"hi" password:@"hi" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    if (succeeded) {
        NSLog(@"User registration successful");
    }
    else {
        NSLog(@"User registration failed: %@", error);
    }
}]; */

+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(PFUserResultBlock)completion;

// example usage of loginUser
/* [User loginUser:@"hi" password:@"hi" withCompletion:^(PFUser * _Nullable user, NSError * _Nullable error) {
    if (user) {
        NSLog(@"User login successful");
    }
    else {
        NSLog(@"User login failed: %@", error);
    }
}]; */

+ (void)logoutUser:(PFUserLogoutResultBlock)completion;

// example usage of logoutUser
/* [User logoutUser:^(NSError * _Nullable error) {
 if (error) {
 NSLog(@"Logout user failed: %@", error);
 }
 else {
 NSLog(@"Logout user successful!");
 }
 }]; */

+ (void)resetDefaultItinerary:(PFUser *)user itinerary:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion;

- (void)updateUser:(NSString *)username password:(NSString *)password defaultItinerary:(Itinerary *)defaultItinerary withCompletion:(PFBooleanResultBlock)completion;


-(void)profilePicture: (PFFileObject *) pP withCompletion:(PFBooleanResultBlock)completion;

@end
