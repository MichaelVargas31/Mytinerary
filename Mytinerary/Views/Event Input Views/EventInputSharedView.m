//
//  EventInputSharedView.m
//  Mytinerary
//
//  Created by ehhong on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "EventInputSharedView.h"

@implementation EventInputSharedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onTapCloseButton:(id)sender {
    NSLog(@"close button tapped");
    [sender dismissViewControllerAnimated:YES completion:nil];
}
@end
