//
//  DailyCalendarViewController.h
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "FSCalendar.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyCalendarViewController : UIViewController

@property (strong, nonatomic) Itinerary *itinerary;
@property (strong, nonatomic) NSDateFormatter *timeOfDayFormatter;
@property (strong, nonatomic) NSArray *eventsArray;

@property (weak, nonatomic) IBOutlet FSCalendar *itineraryFSCalendar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// config default itin functionality
@property BOOL fromLogin;

@end

NS_ASSUME_NONNULL_END
