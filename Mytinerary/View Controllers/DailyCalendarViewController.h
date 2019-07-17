//
//  DailyCalendarViewController.h
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyCalendarViewController : UIViewController

@property (strong, nonatomic) NSCalendar *itineraryCalendar;
@property (strong, nonatomic) NSArray *eventArray;
@property (strong, nonatomic) NSDateFormatter *timeOfDayFormatter;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
