//
//  ViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecorderViewController.h"
#import "StatsViewController.h"
#import <SWRevealViewController.h>
#import "CustomAnimationController.h"
//#import "SettingsViewController.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, SWRevealViewControllerDelegate>//, SettingsViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *videoRecorderOpenButton;
@property (weak, nonatomic) IBOutlet UIButton *statsOpenButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsOpenButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *videoRecorderOpenImageButton;
@property (weak, nonatomic) IBOutlet UIButton *statsOpenImageButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsOpenImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIImageView *statsImage;
@property (weak, nonatomic) IBOutlet UIImageView *settingsImage;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageview;

@property (strong, nonatomic) RecorderViewController *recorderView;
@property (strong, nonatomic) StatsViewController *statsView;

- (IBAction)videoRecorderOpenAction:(id)sender;
- (IBAction)statsOpenAction:(id)sender;
- (IBAction)settingsOpenAction:(id)sender;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL wantsCustomAnimation;

@end
