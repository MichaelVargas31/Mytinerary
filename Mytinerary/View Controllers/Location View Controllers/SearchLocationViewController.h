//
//  SearchLocationViewController.h
//
//
//  Created by samason1 on 7/22/19.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchLocationViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *texxt;
@property (strong, nonatomic) NSArray *results;

@end

NS_ASSUME_NONNULL_END
