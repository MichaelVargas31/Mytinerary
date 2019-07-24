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

@interface EventDetailsViewController () <InputEventViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
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

    
    [self refreshViews];
}

- (void) refreshViews {
    
    // setup date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"h:mm a, MMM d";
    
    // add shared event details title view
    [self.stackView addArrangedSubview:self.titleView];
    [self.titleView.heightAnchor constraintEqualToConstant:TITLE_VIEW_HEIGHT].active = YES;
    // initialize title view labels
    self.titleView.titleLabel.text = self.event.title;
    
    // add shared event description view
    [self.stackView addArrangedSubview:self.descriptionView];
    [self.descriptionView.heightAnchor constraintEqualToConstant:DESCRIPTION_VIEW_HEIGHT].active = YES;
    self.descriptionView.descriptionLabel.text = self.event.eventDescription;
    self.descriptionView.costLabel.text = [NSString stringWithFormat:@"$%@", self.event.cost];
    self.descriptionView.notesLabel.text = self.event.notes;
    
    
    // check to make sure there aren't 3 views already
    if ([self.stackView arrangedSubviews].count == 3) {
        // remove the extra view
        NSArray *subviews = self.stackView.arrangedSubviews;
        UIView *viewToBeRemoved;
        for (int i = 0; i<subviews.count; i++) {
            if (![subviews[i] isKindOfClass:[EventDetailsTitleView class]] && ![subviews[i] isKindOfClass:[EventDetailsDescriptionView class]]) {
                NSLog(@"view = %@", viewToBeRemoved);

                viewToBeRemoved = subviews[i];
                [self.stackView removeArrangedSubview:viewToBeRemoved];
                [viewToBeRemoved removeFromSuperview];
            }
        }
    }
    
    // render view according to category
    NSString *eventCategory = self.event.category; // testing... self.event.category;
    if ([eventCategory isEqualToString:@"activity"]) {
        // add activity view
        [self.stackView insertArrangedSubview:self.activityView atIndex:1];
        [self.activityView.heightAnchor constraintEqualToConstant:ACTIVITY_VIEW_HEIGHT].active = YES;
        // initialize activity view labels
        self.activityView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.activityView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.activityView.addressLabel.text = self.event.address;
    }
    else if ([eventCategory isEqualToString:@"transportation"]) {
        // add transportation view
        [self.stackView insertArrangedSubview:self.transportationView atIndex:1];
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
        [self.stackView insertArrangedSubview:self.foodView atIndex:1];
        [self.foodView.heightAnchor constraintEqualToConstant:FOOD_VIEW_HEIGHT].active = YES;
        // initialize food view labels
        self.foodView.startTimeLabel.text = [dateFormatter stringFromDate:self.event.startTime];
        self.foodView.endTimeLabel.text = [dateFormatter stringFromDate:self.event.endTime];
        self.foodView.foodTypeLabel.text = self.event.foodType;
        self.foodView.addressLabel.text = self.event.address;
    }
    else if ([eventCategory isEqualToString:@"hotel"]) {
        // add hotel view
        [self.stackView insertArrangedSubview:self.hotelView atIndex:1];
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
        InputEventViewController *inputEventViewController = [segue destinationViewController];
        inputEventViewController.event = self.event;
        inputEventViewController.delegate = self;
    }
}


- (void)didUpdateEvent:(nonnull Event *)updatedEvent {
    NSLog(@"Updated event: %@", updatedEvent);
    self.event = updatedEvent;
    [self refreshViews];
}


@end
