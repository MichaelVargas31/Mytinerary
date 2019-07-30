//
//  ViewController.m
//  Mytinerary
//
//  Created by samason1 on 7/30/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self sideMenus];
    
}

-(void) sideMenus{
 
    if(self.revealViewController != nil){
        self.menuButton.target = self.revealViewController;
        self.menuButton.action = @selector(revealToggle:);
        self.revealViewController.rearViewRevealWidth = 275;
        self.revealViewController.rightViewRevealWidth = 160;
        
        self.alertButton.target= self.revealViewController;
        self.alertButton.action = @selector(rightRevealToggle:);
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
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
