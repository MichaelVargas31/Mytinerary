//
//  EventInputFoodView.h
//  Mytinerary
//
//  Created by ehhong on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventInputFoodView : UIView

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *costPickerView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

NS_ASSUME_NONNULL_END
