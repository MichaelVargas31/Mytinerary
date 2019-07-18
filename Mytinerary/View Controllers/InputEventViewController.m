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

static int const EVENT_INPUT_SHARED_VIEW_HEIGHT = 600;
static int const EVENT_INPUT_ACTIVITY_VIEW_HEIGHT = 370;

@interface InputEventViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet EventInputSharedView *eventInputSharedView;
@property (weak, nonatomic) IBOutlet EventInputActivityView *eventInputActivityView;
@property (strong, nonatomic) NSArray *eventCategoryPickerData;

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
    
    // add event input views
    [stackView addArrangedSubview:self.eventInputSharedView];
    [self.eventInputSharedView.heightAnchor constraintEqualToConstant:EVENT_INPUT_SHARED_VIEW_HEIGHT].active = YES;
    
    [stackView addArrangedSubview:self.eventInputActivityView];
    [self.eventInputActivityView.heightAnchor constraintEqualToConstant:EVENT_INPUT_ACTIVITY_VIEW_HEIGHT].active = YES;
    
    // set up shared category picker view
    self.eventInputSharedView.categoryPickerView.delegate = self;
    self.eventInputSharedView.categoryPickerView.dataSource = self;
    self.eventCategoryPickerData = [NSArray arrayWithObjects:@"activity", @"transportation", @"food", @"hotel", nil];
    
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


// picker view functions
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { 
    return self.eventCategoryPickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.eventCategoryPickerData[row];
}

@end
