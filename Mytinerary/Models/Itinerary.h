//  Itinerary.h

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Event.h"

@interface Itinerary : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSNumber *totalCost;
@property (nonatomic, strong) NSNumber *budget;
@property (nonatomic, strong) NSString *title;

+ (void) initNewItinerary:(NSDate *)startTime endTime:(NSDate *)endTime withCompletion:(PFBooleanResultBlock)completion;

- (void) addEventToItinerary:(Event *)event withCompletion:(PFBooleanResultBlock)completion;

@end
