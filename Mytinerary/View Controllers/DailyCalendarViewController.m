//
//  DailyCalendarViewController.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//


/*
 
 Questions:
    - Should formatter be defined as a property of the Daily View Controller?
    - Currently iterating through 'events' array of pointers in itinerary, using the ID to fetch said
            event from parse. More efficient way?
    - How do I access the tableview.rowheight from the UIView file?

 */

#import "DailyCalendarViewController.h"
#import "DailyTableViewCell.h"
#import "DailyCalendarEventUIView.h"
#import "Event.h"
#import "Parse/Parse.h"


@interface DailyCalendarViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DailyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // initializing formatter for calculating cell's times
    self.timeOfDayFormatter = [[NSDateFormatter alloc] init];
    [self.timeOfDayFormatter setDateFormat:@"HH:mm:ss"];
    
    self.tableView.rowHeight = 200;
    
    
    
    NSArray *events = [NSArray arrayWithArray:self.itinerary.events];
    NSMutableArray *eventIDs = [[NSMutableArray alloc] init];
    for (int i =0; i < events.count; i ++) {
//        NSLog(@"event i = %@", events[i]);
        Event *one = events[i];
//        NSLog(@"one.objectID = %@", one.objectId);
        [eventIDs addObject:one.objectId];

    }
    
    PFQuery *query = [Event query];
    [query whereKey:@"objectId" containedIn:eventIDs];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable fullEventArray, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"  recieved:  %@", fullEventArray);
            self.eventArray = fullEventArray;
            NSLog(@"  new array:  %@", self.eventArray);
            for (int i =0; i < self.eventArray.count; i++) {
                DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
                [calEventView createEventViewWithEventModel:self.eventArray[i]];
                [self.tableView addSubview:calEventView]; // will this work??? IT should... if calEventView is being modified at all?
            }
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
    
    
    
//    List<ParseObject> parseObjects = new ArrayList<>();
//    for (String objectId : listObjectId) {
//        parseObjects.add(ParseObject.createWithoutData(ItemModel.class, objectId));
//    }
//
//    ParseObject.fetchAll(parseObjects);
//    // parseObjects will now contain all data retrieved from Parse.
//
//    for (NSInteger i = 0; i < self.itinerary.events.count; i++) {
//        Event *event = self.itinerary.events[i];
//        [event fetchIfNeeded];  // might be whats taking long time
//
//        // Create event & add to tableView
//        DailyCalendarEventUIView *calEventView = [[DailyCalendarEventUIView alloc] init];
//        [calEventView createEventViewWithEventModel:event];
//        [self.tableView addSubview:calEventView]; // will this work??? IT should... if calEventView is being modified at all?
//
//    }
}


/*
#pragma mark - Navigationr

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyEventCell" forIndexPath:indexPath];
    
    // Adding time labels to each cell
    NSDate *midnight = [self.timeOfDayFormatter dateFromString:@"00:00:00"];
    NSDate *newTime = [midnight dateByAddingTimeInterval:1800*indexPath.row];
    cell.calendarTimeLabel.text = [[self.timeOfDayFormatter stringFromDate:newTime] substringToIndex:5];
    
    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 48 half hour increments in day
    return 48;
}

- (void)didTapEvent:(UITapGestureRecognizer *)sender {
    NSLog(@"tapping: %@", self);
}


@end
