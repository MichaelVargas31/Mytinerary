//
//  InputEventViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/18/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "InputEventViewController.h"
#import "EventInputSharedView.h"
#import "EventInputActivityView.h"
#import "EventInputTransportationView.h"
#import "EventInputFoodView.h"
#import "EventInputHotelView.h"
#import "EventInputSubmitView.h"
#import "Event.h"
#import "SearchLocationViewController.h"

static int const EVENT_INPUT_SHARED_VIEW_HEIGHT = 600;
static int const EVENT_INPUT_ACTIVITY_VIEW_HEIGHT = 370;
static int const EVENT_INPUT_TRANSPORTATION_VIEW_HEIGHT = 540;
static int const EVENT_INPUT_FOOD_VIEW_HEIGHT = 460;
static int const EVENT_INPUT_HOTEL_VIEW_HEIGHT = 460;
static int const EVENT_INPUT_SUBMIT_VIEW_HEIGHT = 50;

@interface InputEventViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIStackView *stackView;
@property (strong, nonatomic) UIAlertController *alert;

@property (weak, nonatomic) IBOutlet EventInputSharedView *eventInputSharedView;
@property (weak, nonatomic) IBOutlet EventInputActivityView *eventInputActivityView;
@property (weak, nonatomic) IBOutlet EventInputTransportationView *eventInputTransportationView;
@property (weak, nonatomic) IBOutlet EventInputFoodView *eventInputFoodView;
@property (weak, nonatomic) IBOutlet EventInputHotelView *eventInputHotelView;
@property (weak, nonatomic) IBOutlet EventInputSubmitView *eventInputSubmitView;

@property (strong, nonatomic) NSArray *eventCategoryPickerData;
@property (strong, nonatomic) NSArray *transportationTypePickerData;
@property (strong, nonatomic) NSArray *foodCostPickerData;
@property (strong, nonatomic) NSArray *hotelTypePickerData;

@property (strong, nonatomic) SearchLocationViewController* searchVC;
@end

@implementation InputEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up alert controller
    self.alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"This is an alert."
                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [self.alert addAction:defaultAction];
    
    // make and configure scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSArray *scrollConstraints = [NSArray arrayWithObjects:[scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor], [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor], [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor], [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor], nil];
    [NSLayoutConstraint activateConstraints:scrollConstraints];
    
    // make and configure stack view as subview of scroll view
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 0;
    stackView.distribution = UIStackViewDistributionFill;
    [scrollView addSubview:stackView];
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    NSArray *stackConstraints = [NSArray arrayWithObjects:[stackView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor], [stackView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor], [stackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor], [stackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor], [stackView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor], nil];
    [NSLayoutConstraint activateConstraints:stackConstraints];
    
    // store pointers to stackView and scrollView to render additional input forms
    self.stackView = stackView;
    self.scrollView = scrollView;
    
    // add shared event input view
    [stackView addArrangedSubview:self.eventInputSharedView];
    [self.eventInputSharedView.heightAnchor constraintEqualToConstant:EVENT_INPUT_SHARED_VIEW_HEIGHT].active = YES;
    
    // by default, add activity event input view
    [stackView addArrangedSubview:self.eventInputActivityView];
    [self.eventInputActivityView.heightAnchor constraintEqualToConstant:EVENT_INPUT_ACTIVITY_VIEW_HEIGHT].active = YES;
    
    // add submit button view
    [stackView addArrangedSubview:self.eventInputSubmitView];
    [self.eventInputSubmitView.heightAnchor constraintEqualToConstant:EVENT_INPUT_SUBMIT_VIEW_HEIGHT].active = YES;
    
    // set title of event input (edit or new)
    if (self.event) {
        self.eventInputSharedView.viewTitleLabel.text = @"Edit event";
    }
    else {
        self.eventInputSharedView.viewTitleLabel.text = @"New event";
    }
    
    // setup shared category picker view
    self.eventInputSharedView.categoryPickerView.delegate = self;
    self.eventInputSharedView.categoryPickerView.dataSource = self;
    self.eventCategoryPickerData = [NSArray arrayWithObjects:@"activity", @"transportation", @"food", @"hotel", nil];
    
    // setup activity location text field
    self.eventInputActivityView.locationTextField.delegate = self;
    
    // setup transportation category picker view
    self.eventInputTransportationView.typePickerView.delegate = self;
    self.eventInputTransportationView.typePickerView.dataSource = self;
    self.transportationTypePickerData = [NSArray arrayWithObjects:@"walk", @"bike", @"car", @"public transportation", nil];
    
    // setup food cost picker view
    self.eventInputFoodView.costPickerView.delegate = self;
    self.eventInputFoodView.costPickerView.dataSource = self;
    self.foodCostPickerData = [NSArray arrayWithObjects:@"$", @"$$", @"$$$", @"$$$$", nil];
    
    // setup hotel type picker view
    self.eventInputHotelView.typePickerView.delegate = self;
    self.eventInputHotelView.typePickerView.dataSource = self;
    self.hotelTypePickerData = [NSArray arrayWithObjects:@"hotel", @"campground", @"hostel", @"airbnb", nil];
    
    // if from preexisting event (event details page), prefill fields w/ existing data
    if (self.event) {
        [self prefillEventFields:self.event];
    }
}

// prefill event fields if editing preexisting event
- (void)prefillEventFields:(Event *)event {
    self.eventInputSharedView.titleTextField.text = event.title;
    self.eventInputSharedView.descriptionTextView.text = event.eventDescription;
    [self.eventInputSharedView.startTimeDatePicker setDate:event.startTime];
    [self.eventInputSharedView.endTimeDatePicker setDate:event.endTime];
    
    // set category picker to current event category, prefill category specific fields
    if ([event.category isEqualToString:@"activity"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:0 inComponent:0 animated:YES];
        [self prefillActivityEventFields:event];
    }
    else if ([event.category isEqualToString:@"transportation"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:1 inComponent:0 animated:YES];
        [self prefillTransportationEventFields:event];
    }
    else if ([event.category isEqualToString:@"food"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:2 inComponent:0 animated:YES];
        [self prefillFoodEventFields:event];
    }
    else if ([event.category isEqualToString:@"hotel"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:3 inComponent:0 animated:YES];
        [self prefillHotelEventFields:event];
    }
}

- (void)prefillActivityEventFields:(Event *)event {
    self.eventInputActivityView.locationTextField.text = event.address;
    self.eventInputActivityView.costTextField.text = [NSString stringWithFormat:@"%@", event.cost];
    self.eventInputActivityView.notesTextView.text = event.notes;
}

- (void)prefillTransportationEventFields:(Event *)event {
    self.eventInputTransportationView.startLocationTextField.text = event.address;
    self.eventInputTransportationView.endLocationTextField.text = event.endAddress;
    self.eventInputTransportationView.costTextField.text = [NSString stringWithFormat:@"%@", event.cost];
    self.eventInputTransportationView.notesTextView.text = event.notes;
    
    if ([event.transpoType isEqualToString:@"walk"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:0 inComponent:0 animated:YES];
    }
    else if ([event.transpoType isEqualToString:@"bike"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:1 inComponent:0 animated:YES];
    }
    else if ([event.transpoType isEqualToString:@"car"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:2 inComponent:0 animated:YES];
    }
    else if ([event.transpoType isEqualToString:@"public transportation"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:3 inComponent:0 animated:YES];
    }
}

- (void)prefillFoodEventFields:(Event *)event {
    self.eventInputFoodView.locationTextField.text = event.address;
    self.eventInputFoodView.typeTextField.text = event.foodType;
    self.eventInputFoodView.notesTextView.text = event.notes;
    
    if ([event.foodCost isEqualToString:@"$"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:0 inComponent:0 animated:YES];
    }
    else if ([event.foodCost isEqualToString:@"$$"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:1 inComponent:0 animated:YES];
    }
    else if ([event.foodCost isEqualToString:@"$$$"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:2 inComponent:0 animated:YES];
    }
    else if ([event.foodCost isEqualToString:@"$$$$"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:3 inComponent:0 animated:YES];
    }
}

- (void)prefillHotelEventFields:(Event *)event {
    self.eventInputHotelView.locationTextField.text = event.address;
    self.eventInputHotelView.costTextField.text = [NSString stringWithFormat:@"%@", event.cost];
    self.eventInputHotelView.notesTextView.text = event.notes;
    
    if ([event.hotelType isEqualToString:@"hotel"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:0 inComponent:0 animated:YES];
    }
    else if ([event.hotelType isEqualToString:@"campground"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:1 inComponent:0 animated:YES];
    }
    else if ([event.hotelType isEqualToString:@"hostel"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:2 inComponent:0 animated:YES];
    }
    else if ([event.hotelType isEqualToString:@"airbnb"]) {
        [self.eventInputSharedView.categoryPickerView selectRow:3 inComponent:0 animated:YES];
    }
}

- (IBAction)onTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// on submitting new event form
- (IBAction)onTapSubmitButton:(id)sender {
    int selectedCategoryIdx = (int)[self.eventInputSharedView.categoryPickerView selectedRowInComponent:0];
    NSString *selectedCategory = self.eventCategoryPickerData[selectedCategoryIdx];
    
    // if updating preexisting event
    if (self.event) {
        if ([selectedCategory isEqualToString:@"activity"]) {
            [self updateActivityEvent:self.event];
        }
        else if ([selectedCategory isEqualToString:@"transportation"]) {
            [self updateTransportationEvent:self.event];
        }
        else if ([selectedCategory isEqualToString:@"food"]) {
            [self updateFoodEvent:self.event];
        }
        else if ([selectedCategory isEqualToString:@"hotel"]) {
            [self updateHotelEvent:self.event];
        }
    }
    // if creating a new event
    else {
        Event *event = [[Event alloc] init];
        // initialize event depending on selected event type
        if ([selectedCategory isEqualToString:@"activity"]) {
            event = [self makeActivityEvent];
        }
        else if ([selectedCategory isEqualToString:@"transportation"]) {
            event = [self makeTransportationEvent];
        }
        else if ([selectedCategory isEqualToString:@"food"]) {
            event = [self makeFoodEvent];
        }
        else if ([selectedCategory isEqualToString:@"hotel"]) {
            event = [self makeHotelEvent];
        }
        
        // add new event to current itinerary
        [self.itinerary addEventToItinerary:event withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"event: event successfully added to itin");
            }
            else {
                NSLog(@"event failed to add to itin: %@", error);
            }
        }];
    }
}

- (Event *)makeActivityEvent {
    // testing purposes for now
    NSNumber *latitude = self.searchVC.latitude; //need to add a close button
    NSNumber *longitude = @(0);
    NSString *locationType = @"test type";
    
    float cost = (float)0.0;
    if (![self.eventInputActivityView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputActivityView.costTextField.text floatValue];
    }
    
    Event *event = [Event initActivityEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputActivityView.locationTextField.text latitude:latitude longitude:longitude locationType:locationType startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date cost:cost notes:self.eventInputActivityView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"activity event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing activity event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)updateActivityEvent:(Event *)event {
    // testing purposes for now
    NSNumber *latitude = @(0);
    NSNumber *longitude = @(0);
    NSString *locationType = @"test type";
    
    float cost = (float)0.0;
    if (![self.eventInputActivityView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputActivityView.costTextField.text floatValue];
    }
    
    event = [event updateActivityEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputActivityView.locationTextField.text latitude:latitude longitude:longitude locationType:locationType startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date cost:cost notes:self.eventInputActivityView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"activity event successfully updated!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error updating activity event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)makeTransportationEvent {
    // testing purposes for now
    NSNumber *startLatitude = @(0);
    NSNumber *startLongitude = @(0);
    NSNumber *endLatitude = @(0);
    NSNumber *endLongitude = @(0);
    
    float cost = (float)0.0;
    if (![self.eventInputTransportationView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputTransportationView.costTextField.text floatValue];
    }
    
    int selectedTranspoTypeIdx = (int)[self.eventInputTransportationView.typePickerView selectedRowInComponent:0];
    NSString *selectedTranspoType = self.transportationTypePickerData[selectedTranspoTypeIdx];
    
    Event *event = [Event initTransportationEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text startAddress:self.eventInputTransportationView.startLocationTextField.text startLatitude:startLatitude startLongitude:startLongitude endAddress:self.eventInputTransportationView.endLocationTextField.text endLatitude:endLatitude endLongitude:endLongitude startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date transpoType:selectedTranspoType cost:cost notes:self.eventInputTransportationView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"transportation event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing transportation event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)updateTransportationEvent:(Event *)event {
    // testing purposes for now
    NSNumber *startLatitude = @(0);
    NSNumber *startLongitude = @(0);
    NSNumber *endLatitude = @(0);
    NSNumber *endLongitude = @(0);
    
    float cost = (float)0.0;
    if (![self.eventInputTransportationView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputTransportationView.costTextField.text floatValue];
    }
    
    int selectedTranspoTypeIdx = (int)[self.eventInputTransportationView.typePickerView selectedRowInComponent:0];
    NSString *selectedTranspoType = self.transportationTypePickerData[selectedTranspoTypeIdx];
    
    event = [event updateTransportationEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text startAddress:self.eventInputTransportationView.startLocationTextField.text startLatitude:startLatitude startLongitude:startLongitude endAddress:self.eventInputTransportationView.endLocationTextField.text endLatitude:endLatitude endLongitude:endLongitude startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date transpoType:selectedTranspoType cost:cost notes:self.eventInputTransportationView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"transportation event successfully updated!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error updating transportation event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)makeFoodEvent {
    // testing purposes for now
    NSNumber *latitude = @(0);
    NSNumber *longitude = @(0);
    NSString *locationType = @"test type";
    
    int selectedFoodCostIdx = (int)[self.eventInputFoodView.costPickerView selectedRowInComponent:0];
    NSString *selectedFoodCost = self.foodCostPickerData[selectedFoodCostIdx];
    
    Event *event = [Event initFoodEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputFoodView.locationTextField.text latitude:latitude longitude:longitude locationType:locationType startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date foodType:self.eventInputFoodView.typeTextField.text foodCost:selectedFoodCost notes:self.eventInputFoodView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"food event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing food event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)updateFoodEvent:(Event *)event {
    // testing purposes for now
    NSNumber *latitude = @(0);
    NSNumber *longitude = @(0);
    NSString *locationType = @"test type";
    
    int selectedFoodCostIdx = (int)[self.eventInputFoodView.costPickerView selectedRowInComponent:0];
    NSString *selectedFoodCost = self.foodCostPickerData[selectedFoodCostIdx];
                                  
    event = [event updateFoodEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputFoodView.locationTextField.text latitude:latitude longitude:longitude locationType:locationType startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date foodType:self.eventInputFoodView.typeTextField.text foodCost:selectedFoodCost notes:self.eventInputFoodView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"food event successfully updated!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error updating food event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)makeHotelEvent {
    // testing purposes for now
    NSNumber *latitude = @(0);
    NSNumber *longitude = @(0);
    NSString *locationType = @"test type";
    
    float cost = (float)0.0;
    if (![self.eventInputHotelView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputHotelView.costTextField.text floatValue];
    }
    
    int selectedHotelTypeIdx = (int)[self.eventInputHotelView.typePickerView selectedRowInComponent:0];
    NSString *selectedHotelType = self.hotelTypePickerData[selectedHotelTypeIdx];
    
    Event *event = [Event initHotelEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputHotelView.locationTextField.text latitude:latitude longitude:longitude locationType:locationType startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date hotelType:selectedHotelType cost:cost notes:self.eventInputHotelView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"hotel event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing hotel event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

- (Event *)updateHotelEvent:(Event *)event {
    // testing purposes for now
    NSNumber *latitude = @(0);
    NSNumber *longitude = @(0);
    NSString *locationType = @"test type";
    
    float cost = (float)0.0;
    if (![self.eventInputHotelView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputHotelView.costTextField.text floatValue];
    }
    
    int selectedHotelTypeIdx = (int)[self.eventInputHotelView.typePickerView selectedRowInComponent:0];
    NSString *selectedHotelType = self.hotelTypePickerData[selectedHotelTypeIdx];
    
    event = [event updateHotelEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputHotelView.locationTextField.text latitude:latitude longitude:longitude locationType:locationType startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date hotelType:selectedHotelType cost:cost notes:self.eventInputHotelView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"hotel event successfully updated!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error updating hotel event: %@", error);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
    
    return event;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// picker view functions
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case 0:
            return self.eventCategoryPickerData.count;
        case 1:
            return self.transportationTypePickerData.count;
        case 2:
            return self.foodCostPickerData.count;
        case 3:
            return self.hotelTypePickerData.count;
        default:
            return 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case 0:
            return self.eventCategoryPickerData[row];
        case 1:
            return self.transportationTypePickerData[row];
        case 2:
            return self.foodCostPickerData[row];
        case 3:
            return self.hotelTypePickerData[row];
        default:
            return @"broken";
    }
}

// show additional input fields depending on selected event category
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *selectedCategory = self.eventCategoryPickerData[row];
    
    // if from event category picker
    if (pickerView.tag == 0) {
        // clear previously added category subview before adding new category subview
        NSArray *subviews = [self.stackView arrangedSubviews];
        if (subviews.count > 1) {
            [self.stackView removeArrangedSubview:subviews[1]];
            [subviews[1] removeFromSuperview];
        }
        
        // add corresponding category subview
        if ([selectedCategory isEqualToString:@"activity"]) {
            [self.stackView insertArrangedSubview:self.eventInputActivityView atIndex:1];
            [self.eventInputActivityView.heightAnchor constraintEqualToConstant:EVENT_INPUT_ACTIVITY_VIEW_HEIGHT].active = YES;
        }
        else if ([selectedCategory isEqualToString:@"transportation"]) {
            [self.stackView insertArrangedSubview:self.eventInputTransportationView atIndex:1];
            [self.eventInputTransportationView.heightAnchor constraintEqualToConstant:EVENT_INPUT_TRANSPORTATION_VIEW_HEIGHT].active = YES;
        }
        else if ([selectedCategory isEqualToString:@"food"]) {
            [self.stackView insertArrangedSubview:self.eventInputFoodView atIndex:1];
            [self.eventInputFoodView.heightAnchor constraintEqualToConstant:EVENT_INPUT_FOOD_VIEW_HEIGHT].active = YES;
        }
        else if ([selectedCategory isEqualToString:@"hotel"]) {
            [self.stackView insertArrangedSubview:self.eventInputHotelView atIndex:1];
            [self.eventInputHotelView.heightAnchor constraintEqualToConstant:EVENT_INPUT_HOTEL_VIEW_HEIGHT].active = YES;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"text field did begin editing, %@", textField);
    // segue to location search form
//    [self performSegueWithIdentifier:@"getLocationSegue" sender:nil];
}

@end

