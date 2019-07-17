//
//  ProfileViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ProfileViewController.h"
#import "ItineraryCollectionViewCell.h"
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
    
    //posters per line
    CGFloat postersPerLine=2;
    
    //item size
    CGFloat itemWidth=5;
    CGFloat itemHeight=5;
    layout.itemSize= CGSizeMake(itemWidth, itemHeight);
    
}
-(void) fetchitineraries{
    
    //Itinerary Query
    /*
     PFQuery *iQuery = [Itinerary query];
     [iQuery orderByDescending: @"createdAt"];
     [iQuery includeKey: @"author"];
     iQuery.limit =4;
     
     //fetch data
     [iQuery findObjectsInBackgroundWithBlock:^(NSArray<Itinerary *> * itinerary, NSError *  error) {
     if(itinerary){
     self.iArray = itinerary;
     [self.collectionView reloadData];
     }else{
     //handle error
     }
     }
     
     
     */
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ItineraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItineraryCollectionViewCell" forIndexPath:indexPath];
    
    /*Itinerary *itinerary = self.iArray[indexPath.row];
     PFFileObject *imageFile = itinerary.image;
     [imageFile getDataInBackgroundWithBlock: ^ (NSData *data, NSError *error){
     if (!error){
     UIImage *image = [UIImage imageWithData: data];
     [cell.photoView setImage:image];
     }
     }*/
    
        return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iArray.count;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





@end
