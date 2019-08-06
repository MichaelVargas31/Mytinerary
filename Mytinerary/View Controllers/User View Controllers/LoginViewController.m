//
//  LoginViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "LoginViewController.h"
#import "DailyCalendarViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "Itinerary.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}

//logs in user
- (void)loginUser {
    NSString *userName = self.usernameField.text;
    NSString *passWord = self.passwordField.text;
    
    [User loginUser:userName password:passWord withCompletion:^(PFUser * _Nullable pfuser, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Login failed");
        }
        else {
            NSLog(@"Login was sucessful");

            User *user = User.currentUser;
            [self performSegueWithIdentifier:@"defaultItinerarySegue" sender:user];
        }
    }];
}

- (IBAction)signUpUser:(id)sender {
    //set user properties
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [User signUpUser:username password:password withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error);
        }
        else {
            NSLog(@"User sign up successful");
            [self performSegueWithIdentifier:@"defaultItinerarySegue" sender:User.currentUser];
        }
    }];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"defaultItinerarySegue"]) {
        SWRevealViewController *revealViewController = [segue destinationViewController];
        User *user = sender;
        
        if (!user.defaultItinerary) {
            // in this case, you head straight to profile => no single itinerary necessary
            revealViewController.nextSegue = @"ToProfileSegue";
        } else {
            revealViewController.itinerary = user.defaultItinerary;
            revealViewController.loadItinerary = true;
        }
    }
}


@end
