//
//  InputItineraryViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/17/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "InputItineraryViewController.h"
#import "InputValidation.h"
#import "Itinerary.h"

@interface InputItineraryViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimeDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimeDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;

@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation InputItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // set up alert controller
    self.alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"This is an alert."
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [self.alert addAction:defaultAction];
}

- (IBAction)onTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapCreateItinerary:(id)sender {
    NSString *title = self.titleTextField.text;
    NSDate *startTime = self.startTimeDatePicker.date;
    NSDate *endTime = self.endTimeDatePicker.date;
    NSNumber *budget = @([self.budgetTextField.text floatValue]);
    
    NSString *itinValidity = [InputValidation itineraryValidation:title startTime:startTime endTime:endTime budget:budget];
    
    // if itinerary not valid
    if (![itinValidity isEqualToString:@""]) {
        self.alert.message = itinValidity;
        [self presentViewController:self.alert animated:YES completion:nil];
    }
    else {
        // create new itinerary
        [Itinerary initNewItinerary:title startTime:startTime endTime:endTime budget:budget withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Itinerary successfully created!");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                NSLog(@"Error creating itinerary: %@", error);
            }
        }];
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
