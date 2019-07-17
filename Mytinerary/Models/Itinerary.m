//  Itinerary.m

#import "Itinerary.h"
#import "Parse/Parse.h"
#import "Event.h"

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

// add event to an itinerary's list of events
- (void) addEventToItinerary:(Event *)event withCompletion:(PFBooleanResultBlock)completion {
    [self fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error fetching itinerary events: %@", error);
        }
        else {
            self.events = [self.events arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:event, nil]];
            [self saveInBackgroundWithBlock:completion];
        }
    }];
}

@end
