//
//  ProfileViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ProfileViewController.h"
#import "DailyCalendarViewController.h"
#import "ItineraryCollectionViewCell.h"
#import "Itinerary.h"
#import "Parse/Parse.h"


@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation ProfileViewController

 // Do any additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    //fetch itineraries
    [self fetchitineraries];
    
    //flow layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    //spacing
    
    //posters per line - (maybe) CGFloat postersPerLine=2;
    
    //item size
    //Fix size later to make it look better
    CGFloat itemWidth=100;
    CGFloat itemHeight=100;
    layout.itemSize= CGSizeMake(itemWidth, itemHeight);
    
}
-(void) fetchitineraries{
    
    //Itinerary Query
    
     PFQuery *iQuery = [Itinerary query];
     [iQuery orderByDescending: @"createdAt"];
     [iQuery includeKey: @"author"];
     iQuery.limit =6;
     
     //fetch data
     [iQuery findObjectsInBackgroundWithBlock:^(NSArray<Itinerary *> * itinerary, NSError *  error) {
     if(itinerary){
         self.iArray = itinerary;
         NSLog(@"%@", self.iArray);
         [self.collectionView reloadData];
     }
     else{
         //handle error
     }
     }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ItineraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItineraryCollectionViewCell" forIndexPath:indexPath];
   
    Itinerary *itinerary = self.iArray[indexPath.item];

    cell.title.text=itinerary.title;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.iArray.count;
   }



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"yourSegue" sender:self];
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", self);
    // this is really a collectionViewCell
    UICollectionViewCell *tappedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"calendarSegue" sender:tappedCell];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        DailyCalendarViewController *dailyCalendarVC = [segue destinationViewController];
        ItineraryCollectionViewCell *tappedCell = sender;
        NSLog(@"Tapped Cell name: %@", tappedCell.title);
        
        // create indexPath, which specifies exactly which cell we're referencing
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        dailyCalendarVC.itinerary = [self.iArray objectAtIndex:indexPath.item];
        
    } else {
        NSLog(@"If you're getting this message, you need to edit the prepareForSegue() method to add another segue");
    }
}



@end
