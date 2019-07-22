//
//  LoginViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}

//logs in user 
- (void) loginUser {
    NSString *userName = self.usernameField.text;
    NSString *passWord = self.passwordField.text;

    [PFUser logInWithUsernameInBackground:userName password:passWord block:^(PFUser * user, NSError *  error) {
        
        if(error != nil){
            NSLog(@"Login failed");
        } else {
            NSLog(@"Login was sucessful");
           
            [self performSegueWithIdentifier:@"login" sender:nil];
        }
    }];
}

- (IBAction)signUpUser:(id)sender {
    //initialize a new user object
    PFUser *newU = [PFUser user];
    
    //set user properties
    newU.username=self.usernameField.text;
    newU.password=self.passwordField.text;
    
    //call sign up function on user object
    [newU signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error !=nil){
            NSLog(@"Error: %@",error.localizedDescription );
        }
        else {
            NSLog(@"User sign up successful");
            [self performSegueWithIdentifier:@"login" sender:nil];
        }
    }];
    
    
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
