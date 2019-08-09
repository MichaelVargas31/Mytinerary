//
//  ItineraryCollectionViewCell.h
//  Mytinerary
//
//  Created by samason1 on 7/17/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItineraryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Itinerary *itinerary;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

NS_ASSUME_NONNULL_END
