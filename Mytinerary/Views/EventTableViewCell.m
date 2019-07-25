//
//  EventTableViewCell.m
//  Mytinerary
//
//  Created by ehhong on 7/24/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Event.h"
#import "DateFormatter.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
// cell initialization from cell not working at the moment; can't pass in event obj
    
//    NSDateFormatter *dateFormatter = [DateFormatter formatter];
//    
//    self.titleLabel.text = self.event.title;
//    self.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
//    self.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
//    self.descriptionLabel.text = self.event.eventDescription;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
