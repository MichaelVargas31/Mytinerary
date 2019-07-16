//  Itinerary.m

#import "Itinerary.h"
#import "Parse/Parse.h"

@implementation Itinerary

@dynamic startTime;
@dynamic endTime;
@dynamic author;
@dynamic events;
@dynamic totalCost;
@dynamic budget;

+ (nonnull NSString *)parseClassName {
    return @"Itinerary";
}

// initialize a new itinerary with current user and given start/end times
+ (void) initNewItinerary:(NSDate *)startTime endTime:(NSDate *)endTime withCompletion:(PFBooleanResultBlock)completion {

    Itinerary *itinerary = [Itinerary new];
    
    itinerary.author = [PFUser currentUser];
    itinerary.startTime = startTime;
    itinerary.endTime = endTime;
    itinerary.totalCost = @(0);
    itinerary.budget = @(0);
    
    NSArray *eventsArray = [[NSArray alloc] init];
    itinerary.events = eventsArray;
    
    [itinerary saveInBackgroundWithBlock:completion];
}

//- (void) addEventToItinerary:(Event *)event {
//
//}

@end
