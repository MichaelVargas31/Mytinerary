//
//  AppDelegate.m
//  Mytinerary
//
//  Created by michaelvargas on 7/16/19.
//  Copyright © 2019 michaelvargas. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "DailyCalendarViewController.h"
#import "User.h"
#import "LoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"mytinerary";
        configuration.server = @"https://mytinerary-fbu.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    
    

        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
    
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        

    //Directly load profile view if there is a cached user already present
   /* if(PFUser.currentUser) {
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
            //@"Profile" is the ID for the navigation view controller in which profile page is embedded in
        User *currentUser = [User initUserWithPFUser:PFUser.currentUser];
        
        
        
        if (currentUser.defaultItinerary) {
           /* DailyCalendarViewController *dailyCalendarViewController = [storyboard instantiateViewControllerWithIdentifier:@"DailyCalendarViewController"];
            dailyCalendarViewController.itinerary = currentUser.defaultItinerary;
            dailyCalendarViewController.fromLogin = true; // flag that fetches itinerary
            self.window.rootViewController = dailyCalendarViewController;*/
             // self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavCont"];
            
            
            
          /*  UINavigationController *loginnavi = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
            
            UIViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]; //if you assigned this ID is storyboard
            UIViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"DailyCalendarViewController"];  //if you assigned this ID is storyboard
            UIViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            NSArray *controllers = @[vc2, vc3];
            //UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
            
            UINavigationController *navcontrolle = (UINavigationController *)loginnavi;
            [navcontrolle setViewControllers:controllers];
           
           
            
            
            
            
            
            
            
             self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        }
        else {
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            //ProfileNavigationController
        }
    }*/
   
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
