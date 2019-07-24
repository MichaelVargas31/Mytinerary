//
//  SearchLocationViewController.h
//
//
//  Created by samason1 on 7/22/19.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SearchLocationDelegate;

@interface SearchLocationViewController : UITableViewController

// for passing data
@property (nonatomic, weak) id<SearchLocationDelegate> delegate;
@property (nonatomic, weak) UITextField *textField;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *texxt;
@property (strong, nonatomic) NSArray *results;

@end

// protocol to pass data from location search view --> input event view
@protocol SearchLocationDelegate

- (void)didTapLocation:(Location *)location textField:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END
