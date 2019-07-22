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
#import "InputEventViewController.h"

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
    
    // setup date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"h:mm a, MMM d";
    
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
    
    // render view according to category
    NSString *eventCategory = @"activity"; // testing... self.event.category;
    if ([eventCategory isEqualToString:@"activity"]) {
        // add activity view
        [stackView insertArrangedSubview:self.activityView atIndex:1];
        [self.activityView.heightAnchor constraintEqualToConstant:ACTIVITY_VIEW_HEIGHT].active = YES;
        // initialize activity view labels
        self.activityView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.activityView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.activityView.addressLabel.text = self.event.address;
    }
    else if ([eventCategory isEqualToString:@"transportation"]) {
        // add transportation view
        [stackView insertArrangedSubview:self.transportationView atIndex:1];
        [self.transportationView.heightAnchor constraintEqualToConstant:TRANSPORTATION_VIEW_HEIGHT].active = YES;
        // initialize transportation view labels
        self.transportationView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.transportationView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.transportationView.transpoTypeLabel.text = self.event.transpoType;
        self.transportationView.startAddressLabel.text = self.event.address;
        self.transportationView.endAddressLabel.text = self.event.endAddress;
    }
    else if ([eventCategory isEqualToString:@"food"]) {
        // add food view
        [stackView insertArrangedSubview:self.foodView atIndex:1];
        [self.foodView.heightAnchor constraintEqualToConstant:FOOD_VIEW_HEIGHT].active = YES;
        // initialize food view labels
        self.foodView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.foodView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.foodView.foodTypeLabel.text = self.event.foodType;
        self.foodView.addressLabel.text = self.event.address;
    }
    else if ([eventCategory isEqualToString:@"hotel"]) {
        // add hotel view
        [stackView insertArrangedSubview:self.hotelView atIndex:1];
        [self.hotelView.heightAnchor constraintEqualToConstant:HOTEL_VIEW_HEIGHT].active = YES;
        // initialize hotel view labels
        self.hotelView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.hotelView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.hotelView.hotelTypeLabel.text = self.event.hotelType;
        self.hotelView.addressLabel.text = self.event.address;
    }
}

- (IBAction)onTapEditButton:(id)sender {
    [self performSegueWithIdentifier:@"editEventSegue" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editEventSegue"]) {
        InputEventViewController *inputEventVC = [segue destinationViewController];
        inputEventVC.event = self.event;
    }
}


@end
