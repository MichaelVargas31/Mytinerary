//  Event.m

#import "Event.h"
#import "Parse/Parse.h"

@implementation Event

@dynamic startTime;
@dynamic endTime;
@dynamic title;
@dynamic eventDescription;
@dynamic address;
@dynamic category;
@dynamic notes;
@dynamic cost;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

/* initialize a event
(required: title, category, start/end times, location, completion;
 optional: event description, notes) */
- (void) initNewEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString * _Nullable)address category:(NSString *)category startTime:(NSDate *)startTime endTime:(NSDate *)endTime notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // required fields
    self.title = title;
    self.category = category;
    self.startTime = startTime;
    self.endTime = endTime;
    // optional fields
    self.eventDescription = eventDescription;
    self.address = address;
    self.notes = notes;
    
    [self saveInBackgroundWithBlock:completion];
}

/* initialize an activity event
 (required: title, category, start/end times, location, completion;
 optional: event description, cost, notes) */
+ (void) initActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address category:(NSString *)category startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // activity specific field
    event.cost = @(cost);
    
    [event initNewEvent:title eventDescription:eventDescription address:address category:category startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

@end
