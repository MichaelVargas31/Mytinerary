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
@dynamic contactInfo;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

/* initialize a event
(required: title, category, start/end times, completion;
 optional: event description, address, contact info) */
+ (void) initNewEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString * _Nullable)address category:(NSString *)category contactInfo:(NSString * _Nullable)contactInfo startTime:(NSDate *)startTime endTime:(NSDate *)endTime withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // required fields
    event.title = title;
    event.category = category;
    event.startTime = startTime;
    event.endTime = endTime;
    // optional fields
    event.eventDescription = eventDescription;
    event.address = address;
    event.contactInfo = contactInfo;
    
    [event saveInBackgroundWithBlock:completion];
}

@end
