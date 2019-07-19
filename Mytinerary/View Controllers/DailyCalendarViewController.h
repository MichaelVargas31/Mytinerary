//
//  DailyCalendarViewController.h
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyCalendarViewController : UIViewController

@property (strong, nonatomic) Itinerary *itinerary;
@property (strong, nonatomic) NSDateFormatter *timeOfDayFormatter;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)didTapEvent:(UITapGestureRecognizer *)sender;

@end

NS_ASSUME_NONNULL_END
