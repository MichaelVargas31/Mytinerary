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
@dynamic latitude;
@dynamic longitude;
@dynamic locationType;
@dynamic endLatitude;
@dynamic endLongitude;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

/* initialize a event
(required: title, category, start/end times, address, completion;
 optional: event description, notes) */
- (void) initNewEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString * _Nullable)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType category:(NSString *)category startTime:(NSDate *)startTime endTime:(NSDate *)endTime notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // make sure all required fields are filled, validate input
    if ([title isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"Please add a title" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    if ([startTime compare:endTime] != NSOrderedAscending) {
        NSError *error = [NSError errorWithDomain:@"Start time must be before end time" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    if ([address isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"Please add a location" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    
    // required fields
    self.title = title;
    self.category = category;
    self.startTime = startTime;
    self.endTime = endTime;
    self.address = address;
    self.latitude = latitude;
    self.longitude = longitude;
    self.locationType = locationType;
    
    // optional fields
    self.eventDescription = eventDescription;
    self.notes = notes;
    
    [self saveInBackgroundWithBlock:completion];
}

/* initialize an activity event
 (required: title, category, start/end times, address, completion;
 optional: event description, cost, notes) */
+ (void) initActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // activity specific field
    event.cost = @(cost);
    
    [event initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

// update a preexisting activity event
- (void) updateActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    // activity specific field
    self.cost = @(cost);
    
    [self initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

/* initialize a transportation event
 (required: title, category, start/end times, start/end address, transportation type, completion;
 optional: event description, cost, notes) */
+ (void) initTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress startLatitude:(NSNumber *)startLatitude startLongitude:(NSNumber *)startLongitude endAddress:(NSString *)endAddress endLatitude:(NSNumber *)endLatitude endLongitude:(NSNumber *)endLongitude startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    if ([startAddress isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"Please add a start location" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    if ([endAddress isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"Please add an end location" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    
    Event *event = [Event new];
    
    // transportation specific fields
    event.cost = @(cost);
    event.endAddress = endAddress;
    event.endLatitude = endLatitude;
    event.endLongitude = endLongitude;
    event.transpoType = transpoType;
    
    [event initNewEvent:title eventDescription:eventDescription address:startAddress latitude:startLatitude longitude:startLongitude locationType:nil category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

// update preexisting transportation event
- (void) updateTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress startLatitude:(NSNumber *)startLatitude startLongitude:(NSNumber *)startLongitude endAddress:(NSString *)endAddress endLatitude:(NSNumber *)endLatitude endLongitude:(NSNumber *)endLongitude startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    if ([startAddress isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"Please add a start location" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    if ([endAddress isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:@"Please add an end location" code:1 userInfo:nil];
        completion(nil, error);
        return;
    }
    
    // transportation specific fields
    self.cost = @(cost);
    self.endAddress = endAddress;
    self.endLatitude = endLatitude;
    self.endLongitude = endLongitude;
    self.transpoType = transpoType;
    
    [self initNewEvent:title eventDescription:eventDescription address:startAddress latitude:startLatitude longitude:startLongitude locationType:nil category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

/* initialize a food event
 (required: title, category, start/end times, address, food cost, completion;
 optional: event description, food type, notes) */
+ (void) initFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // food specific fields
    event.foodType = foodType;
    event.foodCost = foodCost;
    
    [event initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"food" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

// update preexisting food event
- (void) updateFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // food specific fields
    self.foodType = foodType;
    self.foodCost = foodCost;
    
    [self initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"food" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

/* initialize a hotel event
 (required: title, category, start/end times, address, hotel type, completion;
 optional: event description, cost, notes) */
+ (void) initHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    Event *event = [Event new];
    
    // hotel specific fields
    event.hotelType = hotelType;
    event.cost = @(cost);
    
    [event initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"hotel" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}

// update preexisting hotel event
- (void) updateHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // hotel specific fields
    self.hotelType = hotelType;
    self.cost = @(cost);
    
    [self initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"hotel" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
}


@end
