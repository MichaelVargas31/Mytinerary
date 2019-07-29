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

@property (strong, nonatomic) NSDictionary *eventsDictionary;
@property (strong, nonatomic) NSCalendar *calendar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *WeeklyCalendarCollectionView;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *expandBtn;

@property (weak, nonatomic) IBOutlet UIView *expandView;

// config default itin functionality
@property BOOL fromLogin;

@end

NS_ASSUME_NONNULL_END
