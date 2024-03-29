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
#import "EventDetailsDeleteView.h"
#import "InputEventViewController.h"
#import "DateFormatter.h"
#import "Directions.h"
#import "Colors.h"

//static int const TITLE_VIEW_HEIGHT = 100;
//static int const DESCRIPTION_VIEW_HEIGHT = 300;
//static int const ACTIVITY_VIEW_HEIGHT = 82;
//static int const TRANSPORTATION_VIEW_HEIGHT = 228;
//static int const FOOD_VIEW_HEIGHT = 110;
//static int const HOTEL_VIEW_HEIGHT = 110;
//static int const DELETE_VIEW_HEIGHT = 53;

@interface EventDetailsViewController () <InputEventViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic, strong) IBOutlet EventDetailsTitleView *titleView;
@property (nonatomic, strong) IBOutlet EventDetailsDescriptionView *descriptionView;
@property (nonatomic, strong) IBOutlet EventDetailsActivityView *activityView;
@property (nonatomic, strong) IBOutlet EventDetailsTransportationView *transportationView;
@property (nonatomic, strong) IBOutlet EventDetailsFoodView *foodView;
@property (nonatomic, strong) IBOutlet EventDetailsHotelView *hotelView;
@property (nonatomic, strong) IBOutlet EventDetailsDeleteView *deleteView;

- (IBAction)didTapDeleteButton:(id)sender;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshViews];
}

- (void) refreshViews {
    // setup date formatter
    NSDateFormatter *dateFormatter = [DateFormatter hourDateFormatter];
    
    // make and configure scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    NSArray *scrollConstraints = [NSArray arrayWithObjects:[scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor], [scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor], [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor], [scrollView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor], nil];
    
    [NSLayoutConstraint activateConstraints:scrollConstraints];
    
    [scrollView addSubview:self.stackView];
    
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
    
    // add shared event details title view
    [self.stackView addArrangedSubview:self.titleView];
//    [self.titleView.heightAnchor constraintEqualToConstant:TITLE_VIEW_HEIGHT].active = YES;
    // initialize title view labels
    self.titleView.titleLabel.text = self.event.title;
    
    // check to make sure there aren't 4 views already.
    if ([self.stackView arrangedSubviews].count == 4) {
        // remove the extra view
        NSArray *subviews = self.stackView.arrangedSubviews;
        UIView *viewToBeRemoved;
        for (int i = 0; i<subviews.count; i++) {
            if (!([subviews[i] isKindOfClass:[EventDetailsTitleView class]] || [subviews[i] isKindOfClass:[EventDetailsDescriptionView class]] || [subviews[i] isKindOfClass:[EventDetailsDeleteView class]])) {

                viewToBeRemoved = subviews[i];
                [self.stackView removeArrangedSubview:viewToBeRemoved];
                [viewToBeRemoved removeFromSuperview];
            }
        }
    }
    
    // render view according to category
    NSString *eventCategory = self.event.category;
    if ([eventCategory isEqualToString:@"activity"]) {
        // add activity view
        [self.stackView addArrangedSubview:self.activityView];
//        [self.activityView.heightAnchor constraintEqualToConstant:ACTIVITY_VIEW_HEIGHT].active = YES;
        self.activityView.backgroundColor = [Colors lightGoldColor];
        
        // initialize activity view labels
        self.activityView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.activityView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.activityView.addressLabel.text = self.event.address;
    }
    else if ([eventCategory isEqualToString:@"transportation"]) {
        // add transportation view
        [self.stackView addArrangedSubview:self.transportationView];
//        [self.transportationView.heightAnchor constraintEqualToConstant:TRANSPORTATION_VIEW_HEIGHT].active = YES;
        self.transportationView.backgroundColor = [Colors lightPurpleColor];
        
        // initialize transportation view labels
        self.transportationView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.transportationView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.transportationView.transpoTypeLabel.text = self.event.transpoType;
        self.transportationView.startAddressLabel.text = self.event.address;
        self.transportationView.endAddressLabel.text = self.event.endAddress;
    }
    else if ([eventCategory isEqualToString:@"food"]) {
        // add food view
        [self.stackView addArrangedSubview:self.foodView];
//        [self.foodView.heightAnchor constraintEqualToConstant:FOOD_VIEW_HEIGHT].active = YES;
        self.foodView.backgroundColor = [Colors lightRedColor];
        
        // initialize food view labels
        self.foodView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.foodView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.foodView.foodTypeLabel.text = self.event.foodType;
        self.foodView.addressLabel.text = self.event.address;
    }
    else if ([eventCategory isEqualToString:@"hotel"]) {
        // add hotel view
        [self.stackView addArrangedSubview:self.hotelView];
//        [self.hotelView.heightAnchor constraintEqualToConstant:HOTEL_VIEW_HEIGHT].active = YES;
        self.hotelView.backgroundColor = [Colors lightLightBlueColor];
        
        // initialize hotel view labels
        self.hotelView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.hotelView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.hotelView.hotelTypeLabel.text = self.event.hotelType;
        self.hotelView.addressLabel.text = self.event.address;
    }
    
    // add shared event description view
    [self.stackView addArrangedSubview:self.descriptionView];
//    [self.descriptionView.heightAnchor constraintEqualToConstant:DESCRIPTION_VIEW_HEIGHT].active = YES;
    self.descriptionView.descriptionLabel.text = self.event.eventDescription;
    self.descriptionView.costLabel.text = [NSString stringWithFormat:@"$%@", self.event.cost];
    self.descriptionView.notesLabel.text = self.event.notes;
    
    // add delete event view
    [self.stackView insertArrangedSubview:self.deleteView atIndex:3];
//    [self.deleteView.heightAnchor constraintEqualToConstant:DELETE_VIEW_HEIGHT].active = YES;
}

- (IBAction)onTapEditButton:(id)sender {
    [self performSegueWithIdentifier:@"editEventSegue" sender:self];
}

- (IBAction)onTapOpenMapsButton:(id)sender {
    [Directions openTransportationEventInMaps:self.event];
}

- (void)didUpdateEvent:(nonnull Event *)updatedEvent {
    self.event = updatedEvent;
    [self refreshViews];
    
    // refresh daily calendar view
    [self.delegate didUpdateEvent:updatedEvent];
}



- (IBAction)didTapDeleteButton:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete Event?" message:@"Are you sure you want to delete this event. This cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    
    // create Delete and Cancel buttons to alert
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // if the user confirms the delete:
        if (action) {
            [self.delegate didDeleteEvent:self.event];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editEventSegue"]) {
        InputEventViewController *inputEventViewController = [segue destinationViewController];
        inputEventViewController.event = self.event;
        inputEventViewController.delegate = self;
    }
}

@end
