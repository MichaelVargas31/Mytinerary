//
//  InputItineraryViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/17/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "InputItineraryViewController.h"
#import "AppDelegate.h"
#import "DailyCalendarViewController.h"
#import "InputValidation.h"
#import "Itinerary.h"
#import "Calendar.h"
#import "SWRevealViewController.h"


@interface InputItineraryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *addOrEditItneraryLabel;
@property (weak, nonatomic) IBOutlet UIButton *createOrSaveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimeDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimeDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
@property BOOL itineraryIsNew;  // True if you are CREATING itinerary

@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation InputItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // adjust date pickers
    [self.startTimeDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.endTimeDatePicker setDatePickerMode:UIDatePickerModeDate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // set up alert controller
    self.alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"This is an alert."
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [self.alert addAction:defaultAction];
    [self adjustViewControllerAccordingToNew];
}


// Changes the labels of the VC (ADD or EDIT itinerary, and CREATE or EDIT itinerary) and its properties
- (void)adjustViewControllerAccordingToNew {
    self.itineraryIsNew = (self.itinerary) ? NO:YES;
    
    if (self.itineraryIsNew) {
        self.addOrEditItneraryLabel.text = @"Add Itinerary";
        [self.createOrSaveButton setTitle:@"Create" forState:UIControlStateNormal];
    } else {
        self.addOrEditItneraryLabel.text = @"Edit Itinerary";
        self.titleTextField.text = self.itinerary.title;
        self.startTimeDatePicker.date = self.itinerary.startTime;
        self.endTimeDatePicker.date = self.itinerary.endTime;
        self.budgetTextField.text = [NSString stringWithFormat:@"%@", self.itinerary.budget];
        [self.createOrSaveButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}

- (IBAction)onTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapCreateItinerary:(id)sender {
    NSString *title = self.titleTextField.text;
    // adjusting start and end TIMES according to date
    NSCalendar *calendar = [Calendar gregorianCalendarWithUTCTimeZone];
    NSDate *startTime = [calendar startOfDayForDate:self.startTimeDatePicker.date];
    NSDateComponents *endOfDay = [NSDateComponents new];
    endOfDay.hour = 23;
    endOfDay.minute = 59;
    endOfDay.second = 59;
    NSDate *endTime = [calendar dateByAddingComponents:endOfDay toDate:[calendar startOfDayForDate:self.endTimeDatePicker.date] options:0];
    NSNumber *budget = @([self.budgetTextField.text floatValue]);
    
    NSString *itinValidity = [InputValidation itineraryValidation:title startTime:startTime endTime:endTime budget:budget];
    
    // if itinerary not valid
    if (![itinValidity isEqualToString:@""]) {
        self.alert.message = itinValidity;
        [self presentViewController:self.alert animated:YES completion:nil];
    } else {
        // Edit existing itinerary
        self.itinerary.title = title;
        self.itinerary.startTime = startTime;
        self.itinerary.endTime = endTime;
        self.itinerary.budget = budget;
        
        if (!self.itineraryIsNew) {
            [self.itinerary updateItinerary:self.itinerary];
            [self dismissViewControllerAnimated:YES completion:nil];
            // UPDATE DETAILS VIEW (after editing itin, update itin details view)

        } else {
            self.itinerary = [Itinerary initNewItinerary:title startTime:startTime endTime:endTime budget:budget withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self performSegueWithIdentifier:@"AddNewItineraryToDailyCalendarSegue" sender:nil];
                }
                else {
                    NSLog(@"Error creating itinerary: %@", error);
                    self.alert.message = error.domain;
                    [self presentViewController:self.alert animated:YES completion:nil];
                }
            }];
        }
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddNewItineraryToDailyCalendarSegue"]) {
        SWRevealViewController *revealViewController = [segue destinationViewController];
        revealViewController.itinerary = self.itinerary;
        revealViewController.loadItinerary = true;
//        UINavigationController *dailyCalNavigationController = [segue destinationViewController];
//        DailyCalendarViewController *dailyCalendarViewController = [[dailyCalNavigationController viewControllers] firstObject];
//        dailyCalendarViewController.itinerary = self.itinerary;
        
    } else {
        NSLog(@"not here man");
    }
}


@end
