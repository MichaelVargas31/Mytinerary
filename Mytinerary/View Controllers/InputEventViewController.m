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

static int const EVENTINPUTSHAREDVIEWHEIGHT = 600;
static int const EVENTINPUTACTIVITYVIEWHEIGHT = 370;

@interface InputEventViewController ()

@property (weak, nonatomic) IBOutlet EventInputSharedView *eventInputSharedView;
@property (weak, nonatomic) IBOutlet EventInputActivityView *eventInputActivityView;

@end

@implementation InputEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [stackView addArrangedSubview:self.eventInputActivityView];
    
    // set view heights
    [self.eventInputSharedView.heightAnchor constraintEqualToConstant:EVENTINPUTSHAREDVIEWHEIGHT].active = YES;
    [self.eventInputActivityView.heightAnchor constraintEqualToConstant:EVENTINPUTACTIVITYVIEWHEIGHT].active = YES;
    
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

@end
