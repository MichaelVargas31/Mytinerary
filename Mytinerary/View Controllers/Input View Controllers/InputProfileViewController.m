//
//  InputProfileViewController.m
//  Mytinerary
//
//  Created by ehhong on 8/6/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "InputProfileViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "Itinerary.h"

@interface InputProfileViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *defaultItineraryPicker;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation InputProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add ability to tap out to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // prof pic is a circle
    self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.width / 2;
    
    // setup alert controller
    self.alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"This is an alert."
                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [self.alert addAction:defaultAction];
    
    // prefill username/password text fields
    // You have to fetch all the arrays with the author being this person
    [self fetchUserItineraries];
    [self fetchProfilePicture];
    
    User *user = User.currentUser;
    self.usernameTextField.text = user.username;

    // fill in defaultItineraryPicker
    self.defaultItineraryPicker.delegate = self;
    self.defaultItineraryPicker.dataSource = self;
}

- (void)fetchUserItineraries {
    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query whereKey:@"author" equalTo:User.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            self.itineraries = objects;
            // prefill with current default Itinerary
            User *user = User.currentUser;

            if (user.defaultItinerary) {
                NSLog(@"default itin: %@", user.defaultItinerary);
                NSUInteger defaultItinIdx = [self.itineraries indexOfObjectPassingTest:^BOOL(Itinerary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return [obj.objectId isEqualToString:user.defaultItinerary.objectId];
                }];
                [self.defaultItineraryPicker selectRow:defaultItinIdx inComponent:0 animated:NO];
                [self.defaultItineraryPicker reloadAllComponents];
            }
        } else {
            NSLog(@"Error getting current user's itineraries: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchProfilePicture {
    User *user = User.currentUser;
    PFFileObject *imageFile = user.profilePicture;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            NSLog(@"got profile pic data");
            UIImage *image = [UIImage imageWithData:data];
            [self.profilePictureImage setImage:image];
        }
        else {
            NSLog(@"couldn't get profile pic data: %@", error);
        }
    }];
}

#pragma mark - Buttons & Interactivity
- (IBAction) addProfilePictureBtn:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else {
//        NSLog(@"Camera not available => will use library");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerEditedImage];
    //[self.profilePictureImage setImage:originalImage];
    
    [self resizeImage:originalImage withSize:CGSizeMake(100, 100)];
    [self.profilePictureImage setImage:originalImage];
    
    
    // Dismiss UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onTapSubmitButton:(id)sender {
    int selectedDefaultItinIdx = (int)[self.defaultItineraryPicker selectedRowInComponent:0];
    Itinerary *selectedDefaultItinerary = self.itineraries[selectedDefaultItinIdx];
    
    
    self.profileUser=User.currentUser;
        if(self.profilePictureImage.image){
        NSData *dataImage = UIImagePNGRepresentation(self.profilePictureImage.image);
        PFFileObject *fileImage = [PFFileObject fileObjectWithData:dataImage];
        
        self.profileUser.profilePicture=fileImage;
        
        [self.delegate didSaveProfilePicture];
        
    }
    
    
    [User.currentUser updateUser:self.usernameTextField.text password:self.passwordTextField.text defaultItinerary:selectedDefaultItinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully updated user");
            [self performSegueWithIdentifier:@"EditProfileToProfile" sender:nil];
        }
        else {
            NSLog(@"error updating user: %@", error.domain);
            self.alert.message = error.domain;
            [self presentViewController:self.alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)onTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dismissKeyboard {
    [self.view endEditing:YES];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditProfileToProfile"]) {
        SWRevealViewController *revealVC = [segue destinationViewController];
        revealVC.nextSegue = @"ToProfileSegue";
    }
}

#pragma - picker view

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.itineraries.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.itineraries[row].title;
}

@end
