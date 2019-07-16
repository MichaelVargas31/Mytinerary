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
@property (nonatomic, strong) NSString *contactInfo;

+ (void) initNewEvent:(NSString *)title eventDescription:(NSString * _Nullable)eventDescription address:(NSString * _Nullable)address category:(NSString *)category contactInfo:(NSString * _Nullable)contactInfo startTime:(NSDate *)startTime endTime:(NSDate *)endTime withCompletion:(PFBooleanResultBlock)completion;

@end
