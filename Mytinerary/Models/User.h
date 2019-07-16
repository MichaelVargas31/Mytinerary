//  User.h

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Itinerary.h"

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) Itinerary *defaultItinerary;

+ (void)registerUser:(NSString *)username password:(NSString *)password withCompletion:(PFBooleanResultBlock)completion;

+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(PFUserResultBlock)completion;

+ (void)resetDefaultItinerary:(PFUser *)user itinerary:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion;

@end
