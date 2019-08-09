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
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation InputProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup alert controller
    self.alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"This is an alert."
                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [self.alert addAction:defaultAction];
    
    // prefill username/password text fields
    // You have to fetch all the arrays with the author being this person
    [self fetchUserItineraries];
    User *user = User.currentUser;

    self.usernameTextField.text = user.username;

    // fill in defaultItineraryPicker
    self.defaultItineraryPicker.delegate = self;
    self.defaultItineraryPicker.dataSource = self;
    
    
}



- (void) fetchUserItineraries {
    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query whereKey:@"author" equalTo:User.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            self.itineraries = objects;
            // prefill with current default Itinerary
            User *user = User.currentUser;

            if (user.defaultItinerary) {
                NSLog(@"default itin: %@", user.defaultItinerary);
                NSUInteger defaultItinIdx = [self.itineraries indexOfObjectPassingTest:^BOOL(Itinerary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return [obj.objectId isEqualToString:user.defaultItinerary.objectId];
                }];
                [self.defaultItineraryPicker selectRow:defaultItinIdx inComponent:0 animated:NO];
                [self.defaultItineraryPicker reloadAllComponents];
            }
        } else {
            NSLog(@"Error getting current user's itineraries: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)onTapSubmitButton:(id)sender {
    int selectedDefaultItinIdx = (int)[self.defaultItineraryPicker selectedRowInComponent:0];
    Itinerary *selectedDefaultItinerary = self.itineraries[selectedDefaultItinIdx];
    
    [User.currentUser updateUser:self.usernameTextField.text password:self.passwordTextField.text defaultItinerary:selectedDefaultItinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully updated user");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error updating user: %@", error.domain);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
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
