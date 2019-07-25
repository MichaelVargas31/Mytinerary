//
//  ItineraryDetailsViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ItineraryDetailsViewController.h"
#import "EventTableViewCell.h"
#import "DateFormatter.h"
#import "Parse/Parse.h"

@interface ItineraryDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

// itinerary labels
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;

// events
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *events;

@end

@implementation ItineraryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // setup date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"h:mm a, MMM d";
    
    // initialize labels on view
    self.titleLabel.text = self.itinerary.title;
    self.startTimeLabel.text = [dateFormatter stringFromDate:self.itinerary.startTime];
    self.endTimeLabel.text = [dateFormatter stringFromDate:self.itinerary.endTime];
    self.budgetLabel.text = [NSString stringWithFormat:@"$%@", self.itinerary.budget];
    
    // get itinerary's events
    [self reloadEventTable];
}

- (void)reloadEventTable {
    [Event fetchAllInBackground:self.itinerary.events block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            self.events = objects;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"error loading events: %@", error);
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDateFormatter *dateFormatter = [DateFormatter formatter];
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell"];
    
    Event *event = self.events[indexPath.row];
    
    cell.titleLabel.text = event.title;
    cell.startTimeLabel.text = [dateFormatter stringFromDate:event.startTime];
    cell.endTimeLabel.text = [dateFormatter stringFromDate:event.endTime];
    cell.descriptionLabel.text = event.eventDescription;
    
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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

@end
