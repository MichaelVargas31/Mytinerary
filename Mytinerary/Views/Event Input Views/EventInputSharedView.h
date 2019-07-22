//
//  EventInputSharedView.h
//  Mytinerary
//
//  Created by ehhong on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventInputSharedView : UIView

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimeDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimeDatePicker;

- (IBAction)onTapCloseButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
