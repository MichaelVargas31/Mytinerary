//
//  ProfileViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "DailyCalendarViewController.h"
#import "LoginViewController.h"
#import "ItineraryCollectionViewCell.h"
#import "ProfileCollectionReusableView.h"
#import "Itinerary.h"
#import "Parse/Parse.h"
#import "User.h"


@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ProfileViewController

 // Do any additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    //sets the username on the profile view
    self.usernameLabel.text=User.currentUser.username;

    //fetch itineraries
    [self fetchitineraries];
    
    //flow layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    //spacing
    
    //posters per line (maybe) CGFloat postersPerLine=2;
    
    //item size
    //Fix size later to make it look better
    CGFloat itemWidth = 100;
    CGFloat itemHeight = 100;
    layout.itemSize= CGSizeMake(itemWidth, itemHeight);
    
}
-(void)fetchitineraries {
    //Itinerary Query
    PFQuery *iQuery = [Itinerary query];
    //Search Where author of itineraries is equal to the current user logged in
    [iQuery whereKey:@"author" equalTo:PFUser.currentUser];
    [iQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (!error) {
            [iQuery orderByDescending: @"createdAt"];
            [iQuery includeKey: @"author"];
            iQuery.limit = 100;
            
            //fetch data
            [iQuery findObjectsInBackgroundWithBlock:^(NSArray<Itinerary *> * itinerary, NSError *  error) {
                if(itinerary){
                    self.iArray = itinerary;
                    [self.collectionView reloadData];
                }
                else{
                    NSLog(@"Error fetching data");
                }
            }];
        }
        
    }];
  
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ItineraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItineraryCollectionViewCell" forIndexPath:indexPath];
    Itinerary *itinerary = self.iArray[indexPath.item];
    cell.itinerary = itinerary;
    cell.title.text=itinerary.title;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.iArray.count;
}

// Method to add profile header to collection View
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ProfileCollectionReusableView *profileHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
        NSLog(@"user: %@", PFUser.currentUser);
        User *currentUser = [User initUserWithPFUser:PFUser.currentUser];
        profileHeaderView.usernameLabel.text = currentUser.username;
        reusableview = profileHeaderView;
    }
    
    return reusableview;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"yourSegue" sender:self];
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", self);
    UICollectionViewCell *tappedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"calendarSegue" sender:tappedCell];
}


- (IBAction)logout:(id)sender {
    [User logoutUser:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        DailyCalendarViewController *dailyCalendarVC = [navigationController.viewControllers firstObject];
        ItineraryCollectionViewCell *tappedCell = sender;
        
        // create indexPath, which specifies exactly which cell we're referencing
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        dailyCalendarVC.itinerary = [self.iArray objectAtIndex:indexPath.item];
        
        // reset current user's default itinerary
        Itinerary *itinerary = tappedCell.itinerary;
        [User resetDefaultItinerary:PFUser.currentUser itinerary:itinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"'%@' default itinerary successfully set to: %@", PFUser.currentUser.username, itinerary.title);
            }
            else {
                NSLog(@"failed to set '%@' default itinerary", PFUser.currentUser.username);
            }
        }];
    }
    else {
        NSLog(@"If you're getting this message, you need to edit the prepareForSegue() method to add another segue");
    }
}



@end
