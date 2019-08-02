//
//  EventDetailsViewController.h
//  Mytinerary
//
//  Created by ehhong on 7/22/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EventDetailsViewControllerDelegate

- (void)didUpdateEvent:(Event *)updatedEvent;
- (void)didDeleteEvent:(Event *)deletedEvent;

@end

@interface EventDetailsViewController : UIViewController

@property (nonatomic, weak) id<EventDetailsViewControllerDelegate> delegate;
@property (strong, nonatomic) Event *event;

@end

NS_ASSUME_NONNULL_END
