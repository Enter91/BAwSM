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

@interface ViewController : UIViewController <RecorderViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *videoRecorderOpenButton;
@property (weak, nonatomic) IBOutlet UIButton *statsOpenButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsOpenButton;

@property (strong, nonatomic) RecorderViewController *recorderView;
@property (strong, nonatomic) StatsViewController *statsView;

- (IBAction)videoRecorderOpenAction:(id)sender;
- (IBAction)statsOpenAction:(id)sender;
- (IBAction)settingsOpenAction:(id)sender;

@end
