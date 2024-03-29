//  Event.h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Parse/Parse.h"
#import "Itinerary.h"

@class Itinerary;

@interface Event : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *locationType;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSNumber *cost;

// transportation event
@property (nonatomic, strong) NSString *transpoType;
@property (nonatomic, strong) NSString *endAddress;
@property (nonatomic, strong) NSNumber *endLatitude;
@property (nonatomic, strong) NSNumber *endLongitude;
@property (nonatomic, strong) MKRoute *route;

// food event
@property (nonatomic, strong) NSString *foodCost;
@property (nonatomic, strong) NSString *foodType;

// hotel event
@property (nonatomic, strong) NSString *hotelType;

// checks event object IDs
- (BOOL)isSameEventObj:(Event *)event;


+ (Event *) initActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

- (Event *) updateActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

+ (void) deleteEvent:(Event *)event itinerary:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion;

+ (Event *) initTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress startLatitude:(NSNumber *)startLatitude startLongitude:(NSNumber *)startLongitude endAddress:(NSString *)endAddress endLatitude:(NSNumber *)endLatitude endLongitude:(NSNumber *)endLongitude startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

- (Event *) updateTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress startLatitude:(NSNumber *)startLatitude startLongitude:(NSNumber *)startLongitude endAddress:(NSString *)endAddress endLatitude:(NSNumber *)endLatitude endLongitude:(NSNumber *)endLongitude startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

- (Event *) updateTransportationEventTypeAndTimes:(NSString *)transpoType startTime:(NSDate *)startTime endTime:(NSDate *)endTime withCompletion:(PFBooleanResultBlock)completion;

+ (Event *) initFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

- (Event *) updateFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

+ (Event *) initHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

- (Event *) updateHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude locationType:(NSString *)locationType startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

@end
