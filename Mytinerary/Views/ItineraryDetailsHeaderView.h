//
//  ItineraryDetailsHeaderView.h
//  Mytinerary
//
//  Created by michaelvargas on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItineraryDetailsHeaderView : UIView


@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
@property (weak,nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak,nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak,nonatomic) IBOutlet UILabel *budgetLabel;






@end

NS_ASSUME_NONNULL_END
