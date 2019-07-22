//
//  EventDetailsViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventDetailsTitleView.h"
#import "EventDetailsDescriptionView.h"
#import "EventDetailsActivityView.h"
#import "EventDetailsTransportationView.h"
#import "EventDetailsFoodView.h"
#import "EventDetailsHotelView.h"

static int const TITLE_VIEW_HEIGHT = 100;
static int const DESCRIPTION_VIEW_HEIGHT = 300;
static int const ACTIVITY_VIEW_HEIGHT = 80;
static int const TRANSPORTATION_VIEW_HEIGHT = 180;
static int const FOOD_VIEW_HEIGHT = 110;
static int const HOTEL_VIEW_HEIGHT = 110;

@interface EventDetailsViewController ()

@property (nonatomic, strong) IBOutlet EventDetailsTitleView *titleView;
@property (nonatomic, strong) IBOutlet EventDetailsDescriptionView *descriptionView;
@property (nonatomic, strong) IBOutlet EventDetailsActivityView *activityView;
@property (nonatomic, strong) IBOutlet EventDetailsTransportationView *transportationView;
@property (nonatomic, strong) IBOutlet EventDetailsFoodView *foodView;
@property (nonatomic, strong) IBOutlet EventDetailsHotelView *hotelView;

@end

@implementation EventDetailsViewController

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
    
    // add shared event details title view
    [stackView addArrangedSubview:self.titleView];
    [self.titleView.heightAnchor constraintEqualToConstant:TITLE_VIEW_HEIGHT].active = YES;
    
    // add shared event description view
    [stackView addArrangedSubview:self.descriptionView];
    [self.descriptionView.heightAnchor constraintEqualToConstant:DESCRIPTION_VIEW_HEIGHT].active = YES;
    
    // add activity view (testing purposes only)
    [stackView insertArrangedSubview:self.activityView atIndex:1];
    [self.activityView.heightAnchor constraintEqualToConstant:ACTIVITY_VIEW_HEIGHT].active = YES;

//    if (activity) {
//        // add activity view
//        [stackView insertArrangedSubview:self.activityView atIndex:1];
//        [self.activityView.heightAnchor constraintEqualToConstant:ACTIVITY_VIEW_HEIGHT].active = YES;
//    }
//    else if (transportation) {
//        // add transportation view
//        [stackView insertArrangedSubview:self.transportationView atIndex:1];
//        [self.transportationView.heightAnchor constraintEqualToConstant:TRANSPORTATION_VIEW_HEIGHT].active = YES;
//    }
//    else if (food) {
//        // add food view
//        [stackView insertArrangedSubview:self.foodView atIndex:1];
//        [self.foodView.heightAnchor constraintEqualToConstant:FOOD_VIEW_HEIGHT].active = YES;
//    }
//    else if (hotel) {
//        // add hotel view
//        [stackView insertArrangedSubview:self.hotelView atIndex:1];
//        [self.hotelView.heightAnchor constraintEqualToConstant:HOTEL_VIEW_HEIGHT].active = YES;
//    }
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
