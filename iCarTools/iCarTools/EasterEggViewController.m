//
//  EasterEggViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 05.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "EasterEggViewController.h"
#import "AppDelegate.h"

@interface EasterEggViewController ()

@end

@implementation EasterEggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.revealViewController.panGestureRecognizer.enabled = YES;
    self.revealViewController.tapGestureRecognizer.enabled = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
