//
//  EventDetailsTransportationView.h
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventDetailsTransportationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transpoTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *onTapOpenMapsButton;

@end

NS_ASSUME_NONNULL_END
