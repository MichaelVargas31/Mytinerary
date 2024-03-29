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
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Itinerary";
}

// initialize a new itinerary with current user and given start/end times
+ (Itinerary *)initNewItinerary:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime budget:(NSNumber *)budget image:(UIImage * _Nullable)image withCompletion:(PFBooleanResultBlock)completion {

    Itinerary *itinerary = [Itinerary new];
    itinerary.author = [PFUser currentUser];
    itinerary.startTime = startTime;
    itinerary.endTime = endTime;
    itinerary.totalCost = @(0);
    itinerary.title = title;
    
    if (image) {
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFileObject *imageFile = [PFFileObject fileObjectWithData:imageData];
        itinerary.image = imageFile;
    }

    if (budget > 0) {
        itinerary.budget = budget;
    }
    else {
        itinerary.budget = @(0);
    }
    
    NSArray *eventsArray = [[NSArray alloc] init];
    itinerary.events = eventsArray;
    
    [itinerary saveInBackgroundWithBlock:completion];
    
    return itinerary;
}

- (void)addImageToItinerary:(Itinerary *)itinerary image:(PFFileObject *)image withCompletion:(PFBooleanResultBlock)completion {
    NSLog(@"adding photo to itinerary '%@'", itinerary.title);
    itinerary.image = image;
    [self updateItinerary:itinerary];
}

- (BOOL)isEventDateValid:(NSDate *)eventStartTime eventEndTime:(NSDate *)eventEndTime {
    // ensure that event date is within itinerary dates
    if ([eventStartTime compare:self.startTime] == NSOrderedAscending) {
        return false;
    }
    
    if ([eventEndTime compare:self.endTime] == NSOrderedDescending) {
        return false;
    }
    return true;
}


- (void)updateItinerary:(Itinerary *)updatedItinerary {
    [updatedItinerary saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully saved itinerary '%@'", updatedItinerary.title);
        } else {
            NSLog(@"Error updating itinerary: %@", error.localizedDescription);
        }
    }];
}

+ (void)deleteItinerary:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion {
    // delete all of itinerary's events
    for (Event *eventToBeDeleted in itinerary.events) {
        [eventToBeDeleted deleteInBackground];
    }
    
    [itinerary deleteInBackgroundWithBlock:completion];
}

// add event to an itinerary's list of events
- (void)addEventToItinerary:(Event *)event withCompletion:(PFBooleanResultBlock)completion {
    
    [self fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error fetching itinerary events: %@", error);
        }
        else {
            // if invalid event
            if (![self isEventDateValid:event.startTime eventEndTime:event.endTime]) {
                NSError *error = [NSError errorWithDomain:@"Event times incompatible with itinerary times" code:1 userInfo:nil];
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
