//
//  ItineraryDetailsViewController.m
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ItineraryDetailsViewController.h"
#import "EventTableViewCell.h"
#import "DateHeaderTableViewCell.h"
#import "DateFormatter.h"
#import "Date.h"
#import "Parse/Parse.h"

static const int TABLE_VIEW_HEADER_HEIGHT = 44;

@interface ItineraryDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

// itinerary labels
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;

// events
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSMutableArray *eventsByDay;

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
            self.eventsByDay = eventsByDay;
            
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DateHeaderTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"DateHeaderTableViewCell"];
    NSDate *sectionDate = [Date incrementDayBy:self.itinerary.startTime dayOffset:(int)section];
    
    NSDateFormatter *formatter = [DateFormatter dayDateFormatter];
    header.dateLabel.text = [formatter stringFromDate:sectionDate];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLE_VIEW_HEADER_HEIGHT;
}

@end
