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
@dynamic transpoType;
@dynamic endAddress;
@dynamic foodCost;
@dynamic foodType;
@dynamic hotelType;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

/* initialize a event
(required: title, category, start/end times, address, completion;
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
 (required: title, category, start/end times, address, completion;
 optional: event description, cost, notes) */
+ (void) initActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // activity specific field
    event.cost = @(cost);
    
    [event initNewEvent:title eventDescription:eventDescription address:address category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

/* initialize a transportation event
 (required: title, category, start/end times, start/end address, transportation type, completion;
 optional: event description, cost, notes) */
+ (void) initTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress endAddress:(NSString *)endAddress startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // transportation specific fields
    event.cost = @(cost);
    event.endAddress = endAddress;
    event.transpoType = transpoType;
    
    [event initNewEvent:title eventDescription:eventDescription address:startAddress category:@"transportation" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

/* initialize a food event
 (required: title, category, start/end times, address, food cost, completion;
 optional: event description, food type, notes) */
+ (void) initFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // food specific fields
    event.foodType = foodType;
    event.foodCost = foodCost;
    
    [event initNewEvent:title eventDescription:eventDescription address:address category:@"food" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

/* initialize a hotel event
 (required: title, category, start/end times, address, hotel type, completion;
 optional: event description, cost, notes) */
+ (void) initHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    Event *event = [Event new];
    
    // hotel specific fields
    event.hotelType = hotelType;
    event.cost = @(cost);
    
    [event initNewEvent:title eventDescription:eventDescription address:address category:@"hotel" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}


@end
