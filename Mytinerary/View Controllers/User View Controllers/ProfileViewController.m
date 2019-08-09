//
//  ProfileViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "InputProfileViewController.h"
#import "DailyCalendarViewController.h"
#import "LoginViewController.h"
#import "ItineraryCollectionViewCell.h"
#import "ProfileCollectionReusableView.h"
#import "Itinerary.h"
#import "Parse/Parse.h"
#import "ProgressIndicatorView.h"
#import "User.h"
#import "SWRevealViewController.h"


@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, InputProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noItinerariesLabel;


@end

@implementation ProfileViewController

// Do any additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noItinerariesLabel.alpha = 0;
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    //sets the username on the profile view
    self.usernameLabel.text= User.currentUser.username;
//    self.collectionView.layer.cornerRadius = 10;
    
    //fetch itineraries
    [self fetchitineraries];
    
    // layout of collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 15;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1) - layout.sectionInset.right * 2) / postersPerLine;
    CGFloat itemHeight = 1.3 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
    [self sideMenus];
    [self.collectionView reloadData];
    
}

-(void) sideMenus{
    
    if(self.revealViewController != nil){
        self.mB.target = self.revealViewController;
        self.mB.action = @selector(revealToggle:);
        self.revealViewController.rearViewRevealWidth = 250;
        self.revealViewController.rightViewRevealWidth = 0;
        
        self.aB.target= self.revealViewController;
        self.aB.action = @selector(rightRevealToggle:);
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
}

-(void)fetchitineraries {
    [self.activityIndicator startAnimating];
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
            [iQuery findObjectsInBackgroundWithBlock:^(NSArray<Itinerary *> * itineraryArray, NSError *  error) {
                if(itineraryArray){
                    self.iArray = itineraryArray;
                    
                    
                    [self.collectionView reloadData];
                    [self.activityIndicator stopAnimating];
                }
                else{
                    NSLog(@"Error fetching data");
                    [self.activityIndicator stopAnimating];
                }
            }];
        } else {
            NSLog(@"Error fetching first itinerary: %@", error.localizedDescription);
            [self.activityIndicator stopAnimating];
            self.noItinerariesLabel.alpha = 1;
            
        }
        
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ItineraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItineraryCollectionViewCell" forIndexPath:indexPath];
    Itinerary *itinerary = self.iArray[indexPath.item];
    cell.itinerary = itinerary;
    cell.title.text = itinerary.title;
    if (itinerary.image) {
        NSData *imageData = [itinerary.image getData];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.imageView setImage:image];
            cell.imageView.image = image;
        }
    }
    
    // styling
    cell.layer.cornerRadius = 10;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 32, (CGRectGetHeight(collectionView.frame) / 5));
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iArray.count;
}

// Method to add profile header to collection View
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        ProfileCollectionReusableView *profileHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
        User *currentUser = User.currentUser;
        profileHeaderView.usernameLabel.text = currentUser.username;
        
        // make profile pic a circle
        profileHeaderView.profilePicImageView.layer.cornerRadius = profileHeaderView.profilePicImageView.frame.size.width / 2;
        profileHeaderView.profilePicImageView.layer.masksToBounds = true;
        
        if (currentUser.profilePicture) {
            [currentUser.profilePicture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    [profileHeaderView.profilePicImageView setImage:image];
                    NSLog(@"Sets image");
                } else {
                    NSLog(@"error getting image data: %@", error.localizedDescription);
                }
            }];
        }
        reusableview = profileHeaderView;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *tappedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"calendarSegue" sender:tappedCell];
}

- (IBAction)onTapEditButton:(id)sender {
    [self performSegueWithIdentifier:@"editProfileSegue" sender:nil];
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        
        ItineraryCollectionViewCell *tappedCell = sender;
        Itinerary *itinerary = tappedCell.itinerary;
        
        // reset current user's default itinerary
        [User resetDefaultItinerary:PFUser.currentUser itinerary:itinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"'%@' default itinerary successfully set to: %@", PFUser.currentUser.username, itinerary.title);
            }
            else {
                NSLog(@"failed to set '%@' default itinerary", PFUser.currentUser.username);
            }
        }];
        
        SWRevealViewController *revealViewController = [segue destinationViewController];
        revealViewController.itinerary = itinerary;
        revealViewController.loadItinerary = true;
    }
    else if ([[segue identifier] isEqualToString:@"editProfileSegue"]) {
        InputProfileViewController *inputProfileViewController = [segue destinationViewController];
        inputProfileViewController.itineraries = self.iArray;
    }
    else {
        NSLog(@"If you're getting this message, you need to edit the prepareForSegue() method to add another segue");
    }
}

-(void)didSaveProfilePicture{
    
    
}

@end
