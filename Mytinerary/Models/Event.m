//  Event.m

#import "Event.h"
#import "Parse/Parse.h"
#import "SearchLocationViewController.h"
#import "InputValidation.h"
#import "Directions.h"

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
@dynamic route;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

/* initialize a event
(required: title, category, start/end times, address, completion;
 optional: event description, notes) */
- (Event *) initNewEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString * _Nullable)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType category:(NSString *)category startTime:(NSDate *)startTime endTime:(NSDate *)endTime notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // make sure all required fields are filled, validate input
    NSString *errorStr = [InputValidation eventSharedValidation:title startTime:startTime endTime:endTime address:address];
    if (![errorStr isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:errorStr code:1 userInfo:nil];
        completion(nil, error);
        return nil;
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
    
    return self;
}

- (Event *) updateEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString * _Nullable)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType category:(NSString *)category startTime:(NSDate *)startTime endTime:(NSDate *)endTime notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    // only reassign address if the address has been changed
    if (![self.address isEqualToString:address]) {
        self.address = address;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    Event *updatedEvent = [self initNewEvent:title eventDescription:eventDescription address:self.address latitude:self.latitude longitude:self.longitude locationType:locationType category:category startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    return updatedEvent;
}

/* initialize an activity event
 (required: title, category, start/end times, address, completion;
 optional: event description, cost, notes) */
+ (Event *) initActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // activity specific field
    event.cost = @(cost);
    
    Event *initializedEvent = [event initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return initializedEvent;
}

// update a preexisting activity event
- (Event *) updateActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    // activity specific field
    self.cost = @(cost);
    
    Event *updatedEvent = [self updateEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"activity" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return updatedEvent;
}

/* initialize a transportation event
 (required: title, category, start/end times, start/end address, transportation type, completion;
 optional: event description, cost, notes) */
+ (Event *) initTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress startLatitude:(NSNumber *)startLatitude startLongitude:(NSNumber *)startLongitude endAddress:(NSString *)endAddress endLatitude:(NSNumber *)endLatitude endLongitude:(NSNumber *)endLongitude startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    NSString *errorStr = [InputValidation startEndAddressValidation:startAddress endAddress:endAddress];
    if (![errorStr isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:errorStr code:1 userInfo:nil];
        completion(nil, error);
        return nil;
    }
    
    Event *event = [Event new];
    
    // transportation specific fields
    event.cost = @(cost);
    event.endAddress = endAddress;
    event.endLatitude = endLatitude;
    event.endLongitude = endLongitude;
    event.transpoType = transpoType;
    
    Event *initializedEvent = [event initNewEvent:title eventDescription:eventDescription address:startAddress latitude:startLatitude longitude:startLongitude locationType:nil category:@"transportation" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return initializedEvent;
}

// update preexisting transportation event
- (Event *) updateTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress startLatitude:(NSNumber *)startLatitude startLongitude:(NSNumber *)startLongitude endAddress:(NSString *)endAddress endLatitude:(NSNumber *)endLatitude endLongitude:(NSNumber *)endLongitude startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    NSString *errorStr = [InputValidation startEndAddressValidation:startAddress endAddress:endAddress];
    if (![errorStr isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:errorStr code:1 userInfo:nil];
        completion(nil, error);
        return nil;
    }
    
    // transportation specific fields
    self.cost = @(cost);
    self.transpoType = transpoType;
    
    // only update location if it's been changed
    if (![self.endAddress isEqualToString:endAddress]) {
        self.endAddress = endAddress;
        self.endLatitude = endLatitude;
        self.endLongitude = endLongitude;
    }
    
    Event *updatedEvent = [self updateEvent:title eventDescription:eventDescription address:startAddress latitude:startLatitude longitude:startLongitude locationType:nil category:@"transportation" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return updatedEvent;
}

- (Event *) updateTransportationEventTypeAndTimes:(NSString *)transpoType startTime:(NSDate *)startTime endTime:(NSDate *)endTime withCompletion:(PFBooleanResultBlock)completion {
    Event *updatedEvent = [self updateTransportationEvent:self.title eventDescription:self.eventDescription startAddress:self.address startLatitude:self.latitude startLongitude:self.longitude endAddress:self.endAddress endLatitude:self.endLatitude endLongitude:self.endLongitude startTime:startTime endTime:endTime transpoType:transpoType cost:self.cost.floatValue notes:self.notes withCompletion:completion];
    
    return updatedEvent;
}

/* initialize a food event
 (required: title, category, start/end times, address, food cost, completion;
 optional: event description, food type, notes) */
+ (Event *) initFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    Event *event = [Event new];
    
    // food specific fields
    event.foodType = foodType;
    event.foodCost = foodCost;
    
    Event *initializedEvent = [event initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"food" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return initializedEvent;
}

// update preexisting food event
- (Event *) updateFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // food specific fields
    self.foodType = foodType;
    self.foodCost = foodCost;
    
    Event *updatedEvent = [self updateEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"food" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return updatedEvent;
}

/* initialize a hotel event
 (required: title, category, start/end times, address, hotel type, completion;
 optional: event description, cost, notes) */
+ (Event *) initHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    Event *event = [Event new];
    
    // hotel specific fields
    event.hotelType = hotelType;
    event.cost = @(cost);
    
    Event *initializedEvent = [event initNewEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"hotel" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return initializedEvent;
}

// update preexisting hotel event
- (Event *) updateHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion {
    
    // hotel specific fields
    self.hotelType = hotelType;
    self.cost = @(cost);
    
    Event *updatedEvent = [self updateEvent:title eventDescription:eventDescription address:address latitude:latitude longitude:longitude locationType:locationType category:@"hotel" startTime:startTime endTime:endTime notes:notes withCompletion:completion];
    
    return updatedEvent;
}

#pragma Transportation directions functions

// https://developer.apple.com/documentation/mapkit/mkmapitem/1452207-openmapswithitems?language=objc
// make function that creates 2 placemarks from a transpo event


@end
