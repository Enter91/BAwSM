//
//  AppDelegate.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "TutorialViewController.h"
#import "RecorderViewController.h"
#import "StatsViewController.h"
#import "RegisterUserViewController.h"

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, SWRevealViewControllerDelegate, TutorialViewControllerDelegate, RegisterUserViewControllerDelegate, LoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property (strong, nonatomic) TutorialViewController *tutorial;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) RegisterUserViewController *registerUserViewController;

@property (nonatomic) BOOL orientationIsLocked;
@property (nonatomic) NSUInteger lockedOrientation;

@end

