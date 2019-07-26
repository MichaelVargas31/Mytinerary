//
//  DailyTableViewCell.h
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *calendarTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
//@property (class, nonatomic, assign, readonly) NSNumber *rowHeight;

+ (NSNumber *)returnRowHeight;

@end

NS_ASSUME_NONNULL_END
