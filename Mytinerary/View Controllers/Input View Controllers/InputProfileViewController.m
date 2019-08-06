//
//  InputProfileViewController.m
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "InputProfileViewController.h"
#import "User.h"
#import "Itinerary.h"

@interface InputProfileViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *defaultItineraryPicker;

@end

@implementation InputProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // prefill username/password text fields
    User *user = User.currentUser;
    self.usernameTextField.text = user.username;

    // fill in defaultItineraryPicker
    self.defaultItineraryPicker.delegate = self;
    self.defaultItineraryPicker.dataSource = self;
    
    // prefill with current default Itinerary
    if (user.defaultItinerary) {
        NSLog(@"default itin: %@", user.defaultItinerary);
        NSUInteger defaultItinIdx = [self.itineraries indexOfObjectPassingTest:^BOOL(Itinerary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.objectId isEqualToString:user.defaultItinerary.objectId];
        }];
        [self.defaultItineraryPicker selectRow:defaultItinIdx inComponent:0 animated:NO];
    }
}

- (IBAction)onTapSubmitButton:(id)sender {
}

- (IBAction)onTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - picker view

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.itineraries.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.itineraries[row].title;
}

@end
