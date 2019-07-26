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
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) NSDictionary *eventsDictionary;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSArray *eventViewArray;

@property (weak, nonatomic) IBOutlet FSCalendar *itineraryFSCalendar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *WeeklyCalendarCollectionView;

@end

NS_ASSUME_NONNULL_END
