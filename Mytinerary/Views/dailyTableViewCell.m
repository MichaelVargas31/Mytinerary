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
    // Initialization code
//    self.rowHeight = [NSNumber numberWithInt:100];
//    DailyTableViewCell.rowHeight = [NSNumber numberWithInt:100];
        // can be referenced when coordinating event overlaying, only have to change the height in one place
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//
//+ (void) setRowHeight:(NSNumber *) newNum {
//    self.rowHeight = [newNum copy];
//
//}

+ (NSNumber *) returnRowHeight {
    return  @(DAILY_TABLE_VIEW_CELL_ROW_HEIGHT);
}

@end
