//  Event.h

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Event : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSNumber *cost;

// transportation event
@property (nonatomic, strong) NSString *transpoType;
@property (nonatomic, strong) NSString *endAddress;

// food event
@property (nonatomic, strong) NSString *foodCost;
@property (nonatomic, strong) NSString *foodType;

// hotel event
@property (nonatomic, strong) NSString *hotelType;

+ (void) initActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *_Nullable)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock _Nullable)completion;

- (void) updateActivityEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

+ (void) initTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress endAddress:(NSString *)endAddress startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock _Nullable)completion;

- (void) updateTransportationEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription startAddress:(NSString *)startAddress endAddress:(NSString *)endAddress startTime:(NSDate *)startTime endTime:(NSDate *)endTime transpoType:(NSString *)transpoType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

+ (void) initFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock _Nullable)completion;

- (void) updateFoodEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime foodType:(NSString *)foodType foodCost:(NSString *)foodCost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

+ (void) initHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock _Nullable)completion;

- (void) updateHotelEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString *)address startTime:(NSDate *)startTime endTime:(NSDate *)endTime hotelType:(NSString *)hotelType cost:(float)cost notes:(NSString * _Nullable)notes withCompletion:(PFBooleanResultBlock)completion;

@end
