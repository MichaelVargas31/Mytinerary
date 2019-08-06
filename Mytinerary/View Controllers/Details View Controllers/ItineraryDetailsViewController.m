//
//  ItineraryDetailsViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "SWRevealViewController.h"
#import "ItineraryDetailsViewController.h"
#import "InputItineraryViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "ItineraryDetailsHeaderView.h"
#import "EventDetailsViewController.h"
#import "DateHeaderTableViewCell.h"
#import "DeleteItineraryTableViewCell.h"
#import "Itinerary.h"
#import "User.h"
#import "DateFormatter.h"
#import "Date.h"
#import "Parse/Parse.h"

static const int TABLE_VIEW_HEADER_HEIGHT = 44;

@interface ItineraryDetailsViewController () <UITableViewDelegate, UITableViewDataSource, InputItineraryViewControllerDelegate>


// actions
- (IBAction)didTapDeleteItinerary:(id)sender;
- (IBAction)didTapEdit:(id)sender;

// events
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ItineraryDetailsHeaderView *headerView;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSMutableArray *eventsByDay;

@end

@implementation ItineraryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self configureHeader];
    // get itinerary's events
    [self reloadEventTable];
}



- (void)reloadEventTable {
  
    [self configureHeader];

    // get number of days in itinerary
    NSInteger numItinDays = [Date daysBetweenDate:self.itinerary.startTime andDate:self.itinerary.endTime];
    
    // TODO initialize eventsByDay
    NSMutableArray *eventsByDay = [NSMutableArray arrayWithCapacity:numItinDays];
    for (int i = 0; i < numItinDays; i++) {
        eventsByDay[i] = [NSMutableArray array];
    }
    
    [Event fetchAllInBackground:self.itinerary.events block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            self.events = objects;
            
            // organize events by day
            for (int i = 0; i < self.events.count; i++) {
                Event *event = self.events[i];
                NSInteger itinDayIndex = [Date daysBetweenDate:self.itinerary.startTime andDate:event.startTime] - 1;
                
                if (itinDayIndex >= self.events.count) {
                    NSLog(@"legacy: INVALID EVENT");
                }
                else {
                    [eventsByDay[itinDayIndex] addObject:event];
                }
            }
            
            for (NSMutableArray <Event *>*dayEvents in eventsByDay) {
                // sort events in ascending order by start time
                [dayEvents sortUsingComparator:^NSComparisonResult(Event *event1, Event *event2) {
                    return [event1.startTime compare:event2.startTime];
                }];
            }
            
            self.eventsByDay = eventsByDay;

          [self.tableView reloadData];
        }
        else {
            NSLog(@"error loading events: %@", error);
        }
    }];
}

#pragma mark - Button Functions

- (IBAction)didTapDeleteItinerary:(id)sender {
    
    // display an alert asking for confirmation of deletion
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete Itinerary?" message:@"Are you sure you want to delete this itinerary. This will delete all this itinerary's events. This cannot be undone." preferredStyle:UIAlertControllerStyleAlert];

    // create Delete and Cancel buttons to alert
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
        // if the delete button is pressed again
        if (action) {
            [self deleteItinerary];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"EditItinerarySegue" sender:nil];
}

#pragma mark - Parse Data

- (void)deleteItinerary {
    // delete the itinerary's events individually
    for (Event *eventToBeDeleted in self.itinerary.events) {
        [eventToBeDeleted deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    }
    
    // delete the user's default itinerary
    if (PFUser.currentUser) {
        [PFUser.currentUser removeObjectForKey:@"defaultItinerary"];
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                NSLog(@"Error deleting defaultItinerary: %@", error.localizedDescription);
            }
        }];
    }
    
    // delete itinerary itself
    [self.itinerary deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"You deleted %@", self.itinerary.title);
            
            
            [self performSegueWithIdentifier:@"DeleteItineraryToProfileSegue" sender:nil];
            
            
        } else {
            NSLog(@"The error you got was %@", error.localizedDescription);
        }
    }];
}


#pragma mark - Table View Configuration

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.eventsByDay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dayEvents = self.eventsByDay[section];
    return dayEvents.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDateFormatter *dateFormatter = [DateFormatter hourDateFormatter];
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell"];
    Event *event = self.eventsByDay[indexPath.section][indexPath.row];
    
    cell.titleLabel.text = event.title;
    cell.startTimeLabel.text = [dateFormatter stringFromDate:event.startTime];
    cell.endTimeLabel.text = [dateFormatter stringFromDate:event.endTime];
    cell.descriptionLabel.text = event.eventDescription;
    
    
    // TODO: make colors more appealing here
    if ([event.category isEqualToString:@"activity"]) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    else if ([event.category isEqualToString:@"transportation"]) {
        cell.backgroundColor = [UIColor greenColor];
    }
    else if ([event.category isEqualToString:@"food"]) {
        cell.backgroundColor = [UIColor purpleColor];
    }
    else if ([event.category isEqualToString:@"hotel"]) {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}



- (void)configureHeader {
     // setup date formatter
        NSDateFormatter *dateFormatter = [DateFormatter hourDateFormatter];
    
        // initialize labels on view
        self.headerView.titleLabel.text = self.itinerary.title;
        if (self.itinerary.image) {
            [self.itinerary.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.headerView.imageView setImage:image];
                } else {
                    NSLog(@"error getting image data: %@", error.localizedDescription);
                }
            }];
        }
    
        self.headerView.startTimeLabel.text = [dateFormatter stringFromDate:self.itinerary.startTime];
        self.headerView.endTimeLabel.text = [dateFormatter stringFromDate:self.itinerary.endTime];
        self.headerView.budgetLabel.text = [NSString stringWithFormat:@"$%@", self.itinerary.budget];
        self.tableView.tableHeaderView = self.headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DateHeaderTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"DateHeaderTableViewCell"];
    NSDate *sectionDate = [Date incrementDayBy:self.itinerary.startTime dayOffset:(int)section];
    
    NSDateFormatter *formatter = [DateFormatter dayDateFormatter];
    header.dateLabel.text = [formatter stringFromDate:sectionDate];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DeleteItineraryTableViewCell *footer = [tableView dequeueReusableCellWithIdentifier:@"DeleteItineraryTablveViewCell"];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLE_VIEW_HEADER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ItinDetailsToEventDetailsSegue" sender:self.eventsByDay[indexPath.section][indexPath.row]];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditItinerarySegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        InputItineraryViewController *inputItineraryViewController = [[navigationController viewControllers] firstObject];
        inputItineraryViewController.itinerary = self.itinerary;
        inputItineraryViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"ItinDetailsToEventDetailsSegue"]) {
        EventDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.event = sender;
    } else if ([segue.identifier isEqualToString:@"DeleteItineraryToProfileSegue"]) {
        SWRevealViewController *revealVC = [segue destinationViewController];
        // tells the revealVC which segue we want it to execute next
        revealVC.nextSegue = @"ToProfileSegue";
    }
}


- (void)didSaveItinerary {
    [self configureHeader];
    [self reloadEventTable];
}


@end
