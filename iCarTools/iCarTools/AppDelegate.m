//
//  AppDelegate.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialShowed"] == [NSNumber numberWithBool:YES] || [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialShowed"] == nil) {
        _tutorial = [[TutorialViewController alloc] init];
        _tutorial.delegate = self;
        self.window.rootViewController = _tutorial;
    } else {*/
        //SWReveal
        ViewController *frontViewController = [[ViewController alloc] init];
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithCellsTitlesArray:@[@"opcja 1", @"opcja 2", @"opcja 3"]];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:settingsViewController frontViewController:frontViewController];
        revealController.delegate = self;
        
        self.viewController = revealController;
        
        self.window.rootViewController = self.viewController;
        //end SWReveal
    //}
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([self.viewController.frontViewController isKindOfClass:NSClassFromString(@"RecorderViewController")]) {
        if ([self.viewController.frontViewController respondsToSelector:@selector(stopCamera)]) {
            [(RecorderViewController *)self.viewController.frontViewController stopCamera];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([self.window.rootViewController isKindOfClass:NSClassFromString(@"TutorialViewController")]) {
        [((TutorialViewController *)self.window.rootViewController) recoverCurrentState];
    } else {
        if ([self.viewController.frontViewController isKindOfClass:NSClassFromString(@"RecorderViewController")]) {
            if ([self.viewController.frontViewController respondsToSelector:@selector(initializeCamera)]) {
                [(RecorderViewController *)self.viewController.frontViewController initializeCamera];
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- Rotacje ekranu
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    
    if (self.orientationIsLocked) {
        
        return self.lockedOrientation;
        
    }
    else {
        if (self.window.rootViewController) {
            orientations = [[((SWRevealViewController *)self.window.rootViewController) revealViewController] supportedInterfaceOrientations];
        }
        return orientations;
    }
}

@end
