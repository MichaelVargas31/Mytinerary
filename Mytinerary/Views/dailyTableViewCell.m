//
//  DailyTableViewCell.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "DailyTableViewCell.h"

@implementation DailyTableViewCell

static int const DAILY_TABLE_VIEW_CELL_ROW_HEIGHT = 100;

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (NSNumber *) returnRowHeight {
    return  @(DAILY_TABLE_VIEW_CELL_ROW_HEIGHT);
}

@end
