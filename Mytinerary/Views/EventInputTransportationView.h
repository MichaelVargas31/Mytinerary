//
//  EventInputTransportationView.h
//  Mytinerary
//
//  Created by ehhong on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventInputTransportationView : UIView

@property (weak, nonatomic) IBOutlet UITextField *startLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *endLocationTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

NS_ASSUME_NONNULL_END
