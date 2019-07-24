//
//  LocationCellTableViewCell.h
//  Mytinerary
//
//  Created by samason1 on 7/23/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventAddress;

@end

NS_ASSUME_NONNULL_END
