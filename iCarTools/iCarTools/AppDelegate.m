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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialShowed"] == [NSNumber numberWithBool:NO] || [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialShowed"] == nil) {
        _tutorial = [[TutorialViewController alloc] init];
        _tutorial.delegate = self;
        self.window.rootViewController = _tutorial;
    } else {
        [self setRevealViewController];
        
        if (!_loginManager) {
            _loginManager = [[LoginManager alloc] init];
        }
        [_loginManager setDelegate:self];
        [_loginManager loginUser];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setRevealViewController {
    
    if (![self.window.rootViewController isKindOfClass:NSClassFromString(@"SWRevealViewController")]) {
        ViewController *frontViewController = [[ViewController alloc] init];
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:settingsViewController frontViewController:frontViewController];
        revealController.delegate = self;
        
        [self updateSettingsViewControllerLoginInfo];
        
        if (_tutorial) {
            [_tutorial presentViewController:revealController animated:YES completion:^{
                self.viewController = revealController;
                self.window.rootViewController = self.viewController;
                _tutorial = nil;
            }];
        } else if (_registerUserViewController) {
            [_registerUserViewController presentViewController:revealController animated:YES completion:^{
                self.viewController = revealController;
                self.window.rootViewController = self.viewController;
                _registerUserViewController.delegate = nil;
                _registerUserViewController = nil;
            }];
        } else if (_loginViewController) {
            [_loginViewController presentViewController:revealController animated:YES completion:^{
                self.viewController = revealController;
                self.window.rootViewController = self.viewController;
                _loginViewController.delegate = nil;
                _loginViewController = nil;
            }];
        } else {
            self.viewController = revealController;
            self.window.rootViewController = self.viewController;
        }
        
        frontViewController = nil;
        settingsViewController = nil;
    }
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

- (void)didEndTutorialWithRegistration:(BOOL)wantsRegister {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"tutorialShowed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (wantsRegister) {
        _registerUserViewController = [[RegisterUserViewController alloc] init];
        _registerUserViewController.delegate = self;
        
        [self.window.rootViewController presentViewController:_registerUserViewController animated:YES completion:^{
            self.window.rootViewController = _registerUserViewController;
            _tutorial = nil;
        }];
    } else {
        [self setRevealViewController];
    }
}

- (void)showLoginViewScreen {
    
    __block UIViewController *current = self.window.rootViewController;
    if (!_loginViewController) {
        _loginViewController = [[LoginViewController alloc] init];
    }
    [_loginViewController setDelegate:self];
    [self.window.rootViewController presentViewController:_loginViewController animated:YES completion:^{
        self.window.rootViewController = _loginViewController;
        current = nil;
    }];
    
}

#pragma mark- Delegaty RegisterView, LoginView i LoginManager

- (void)registerUserSuccess {
    [self setRevealViewController];
    
    [self updateSettingsViewControllerLoginInfo];
}

- (void)registerUserAlreadyRegistered {
    _loginViewController = [[LoginViewController alloc] init];
    _loginViewController.delegate = self;
    
    [self.window.rootViewController presentViewController:_loginViewController animated:YES completion:^{
        self.window.rootViewController = _loginViewController;
        if (_registerUserViewController) {
            _registerUserViewController.delegate = nil;
            _registerUserViewController = nil;
        }
    }];
}

- (void)registerUserCancel {
    [self setRevealViewController];
}

- (void)loginWantsRegisterUser {
    _registerUserViewController = [[RegisterUserViewController alloc] init];
    _registerUserViewController.delegate = self;
    
    if ([self.window.rootViewController isKindOfClass:NSClassFromString(@"LoginViewController")]) {
        [_loginViewController presentViewController:_registerUserViewController animated:YES completion:^{
            self.window.rootViewController = _registerUserViewController;
            if (_loginViewController) {
                _loginViewController.delegate = nil;
                _loginViewController = nil;
            }
        }];
    } else if ([self.window.rootViewController isKindOfClass:NSClassFromString(@"SWRevealViewController")]) {
        [self.viewController setFrontViewController:_registerUserViewController animated:YES];
        if (_loginViewController) {
            _loginViewController.delegate = nil;
            _loginViewController = nil;
        }
    } else {
        [self setRevealViewController];
    }
}

- (void)loginSuccess {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![self.window.rootViewController isKindOfClass:NSClassFromString(@"SWRevealViewController")]) {
        [self setRevealViewController];
        
        [self updateSettingsViewControllerLoginInfo];
    }
}

- (void)loginManagerSuccess {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateSettingsViewControllerLoginInfo];
}

- (void)loginManagerFailWithErrorMessage:(NSString *)errorMessage {
    NSLog(@"login error message: %@", errorMessage);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateSettingsViewControllerLoginInfo {
    if ([self.viewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", [[UserInfo sharedInstance] first_name], [[UserInfo sharedInstance] last_name]]);
        [(SettingsViewController *)self.viewController.rearViewController setUserInfoWithName:[NSString stringWithFormat:@"%@ %@", [[UserInfo sharedInstance] first_name], [[UserInfo sharedInstance] last_name]] andAvatar:nil];
    }
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
