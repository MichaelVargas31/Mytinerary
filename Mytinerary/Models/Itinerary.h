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

+ (void) initNewItinerary:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime budget:(NSNumber *)budget withCompletion:(PFBooleanResultBlock)completion;

- (void) addEventToItinerary:(Event *)event withCompletion:(PFBooleanResultBlock)completion;

- (BOOL)isEventDateValid:(NSDate *)eventStartTime eventEndTime:(NSDate *)eventEndTime;

@end
