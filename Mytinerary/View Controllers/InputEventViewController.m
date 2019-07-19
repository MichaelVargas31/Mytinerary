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

static int const EVENT_INPUT_SHARED_VIEW_HEIGHT = 600;
static int const EVENT_INPUT_ACTIVITY_VIEW_HEIGHT = 370;
static int const EVENT_INPUT_TRANSPORTATION_VIEW_HEIGHT = 540;
static int const EVENT_INPUT_FOOD_VIEW_HEIGHT = 460;
static int const EVENT_INPUT_HOTEL_VIEW_HEIGHT = 460;
static int const EVENT_INPUT_SUBMIT_VIEW_HEIGHT = 50;

@interface InputEventViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIStackView *stackView;

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

@end

@implementation InputEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    // setup shared category picker view
    self.eventInputSharedView.categoryPickerView.delegate = self;
    self.eventInputSharedView.categoryPickerView.dataSource = self;
    self.eventCategoryPickerData = [NSArray arrayWithObjects:@"activity", @"transportation", @"food", @"hotel", nil];
    
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
}

- (IBAction)onTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// on submitting new event form
- (IBAction)onTapSubmitButton:(id)sender {
    int selectedCategoryIdx = (int)[self.eventInputSharedView.categoryPickerView selectedRowInComponent:0];
    NSString *selectedCategory = self.eventCategoryPickerData[selectedCategoryIdx];
    
    // initialize event depending on selected event type
    if ([selectedCategory isEqualToString:@"activity"]) {
        [self initActivityEvent];
    }
    else if ([selectedCategory isEqualToString:@"transportation"]) {
        [self initTransportationEvent];
    }
    else if ([selectedCategory isEqualToString:@"food"]) {
        [self initFoodEvent];
    }
    else if ([selectedCategory isEqualToString:@"hotel"]) {
        [self initHotelEvent];
    }
}

- (void)initActivityEvent {
    float cost = (float)0.0;
    if (![self.eventInputActivityView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputActivityView.costTextField.text floatValue];
    }
    
    [Event initActivityEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputActivityView.locationTextField.text startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date cost:cost notes:self.eventInputActivityView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"activity event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing activity event: %@", error);
        }
    }];
}

- (void)initTransportationEvent {
    float cost = (float)0.0;
    if (![self.eventInputTransportationView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputTransportationView.costTextField.text floatValue];
    }
    
    int selectedTranspoTypeIdx = (int)[self.eventInputTransportationView.typePickerView selectedRowInComponent:0];
    NSString *selectedTranspoType = self.transportationTypePickerData[selectedTranspoTypeIdx];
    
    [Event initTransportationEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text startAddress:self.eventInputTransportationView.startLocationTextField.text endAddress:self.eventInputTransportationView.endLocationTextField.text startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date transpoType:selectedTranspoType cost:cost notes:self.eventInputTransportationView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"transportation event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing transportation event: %@", error);
        }
    }];
}

- (void)initFoodEvent {
    int selectedFoodCostIdx = (int)[self.eventInputFoodView.costPickerView selectedRowInComponent:0];
    NSString *selectedFoodCost = self.foodCostPickerData[selectedFoodCostIdx];
    
    [Event initFoodEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputFoodView.locationTextField.text startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date foodType:self.eventInputFoodView.typeTextField.text foodCost:selectedFoodCost notes:self.eventInputFoodView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"food event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing food event: %@", error);
        }
    }];
}

- (void)initHotelEvent {
    float cost = (float)0.0;
    if (![self.eventInputHotelView.costTextField.text isEqualToString:@""]) {
        cost = [self.eventInputHotelView.costTextField.text floatValue];
    }
    
    int selectedHotelTypeIdx = (int)[self.eventInputHotelView.typePickerView selectedRowInComponent:0];
    NSString *selectedHotelType = self.hotelTypePickerData[selectedHotelTypeIdx];
    
    [Event initHotelEvent:self.eventInputSharedView.titleTextField.text eventDescription:self.eventInputSharedView.descriptionTextView.text address:self.eventInputHotelView.locationTextField.text startTime:self.eventInputSharedView.startTimeDatePicker.date endTime:self.eventInputSharedView.endTimeDatePicker.date hotelType:selectedHotelType cost:cost notes:self.eventInputHotelView.notesTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"hotel event successfully initialized!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"error initializing hotel event: %@", error);
        }
    }];
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
            break;
        case 1:
            return self.transportationTypePickerData.count;
            break;
        case 2:
            return self.foodCostPickerData.count;
            break;
        case 3:
            return self.hotelTypePickerData.count;
            break;
        default:
            return 1;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case 0:
            return self.eventCategoryPickerData[row];
            break;
        case 1:
            return self.transportationTypePickerData[row];
            break;
        case 2:
            return self.foodCostPickerData[row];
            break;
        case 3:
            return self.hotelTypePickerData[row];
            break;
        default:
            return @"broken";
            break;
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

@end
