//
//  WeekdayCollectionViewCell.h
//  Mytinerary
//
//  Created by michaelvargas on 7/25/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeekdayCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSArray *eventArray;
@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;

@end

NS_ASSUME_NONNULL_END
