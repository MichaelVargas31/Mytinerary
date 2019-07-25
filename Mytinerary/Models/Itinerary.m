//  Itinerary.m

#import "Itinerary.h"
#import "DateFormatter.h"
#import "Parse/Parse.h"
#import "Event.h"

@implementation Itinerary

@dynamic startTime;
@dynamic endTime;
@dynamic author;
@dynamic events;
@dynamic totalCost;
@dynamic budget;
@dynamic title;

+ (nonnull NSString *)parseClassName {
    return @"Itinerary";
}

// initialize a new itinerary with current user and given start/end times
+ (void) initNewItinerary:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime budget:(NSNumber *)budget withCompletion:(PFBooleanResultBlock)completion {

    Itinerary *itinerary = [Itinerary new];
    
    itinerary.author = [PFUser currentUser];
    itinerary.startTime = startTime;
    itinerary.endTime = endTime;
    itinerary.totalCost = @(0);
    itinerary.title = title;
    
    if (budget > 0) {
        itinerary.budget = budget;
    }
    else {
        itinerary.budget = @(0);
    }
    
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
            // ensure that event date is within itinerary dates
            if ([event.startTime compare:self.startTime] == NSOrderedAscending) {
                NSError *error = [NSError errorWithDomain:@"Event start time cannot be before itinerary start time" code:1 userInfo:nil];
                completion(nil, error);
            }
            else if ([event.endTime compare:self.endTime] == NSOrderedDescending) {
                NSError *error = [NSError errorWithDomain:@"Event end time cannot be after itinerary end time" code:1 userInfo:nil];
                completion(nil, error);
            }
            // if valid event
            else {
                self.events = [self.events arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:event, nil]];
                [self saveInBackgroundWithBlock:completion];
            }
        }
    }];
}

@end
