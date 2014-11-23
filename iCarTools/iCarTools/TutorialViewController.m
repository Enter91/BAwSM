//
//  TutorialViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController () {
    NSLayoutConstraint *backgroundImageXPosition;
    NSLayoutConstraint *iPhoneXPosition;
}
@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-Background"]];
    [self.view addSubview:_backgroundImageView];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backgroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_backgroundImageView attribute:NSLayoutAttributeHeight multiplier:256.0/160.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    backgroundImageXPosition = [NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    [self.view addConstraint:backgroundImageXPosition];
    
    _iPhoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-iPhone"]];
    [self.view addSubview:_iPhoneImageView];
    [_iPhoneImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_iPhoneImageView addConstraint:[NSLayoutConstraint constraintWithItem:_iPhoneImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_iPhoneImageView attribute:NSLayoutAttributeHeight multiplier:763.0/1602.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_iPhoneImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.75/1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_iPhoneImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    iPhoneXPosition = [NSLayoutConstraint constraintWithItem:_iPhoneImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    [self.view addConstraint:iPhoneXPosition];
    
    _permissionTitle = [[UILabel alloc] init];
    [_permissionTitle setFont:[UIFont fontWithName:@"DINPro-Light" size:30.0]];
    [_permissionTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    [_permissionTitle setTextColor:[UIColor whiteColor]];
    [_permissionTitle setTextAlignment:NSTextAlignmentCenter];
    [_permissionTitle setText:NSLocalizedString(@"Tutorial1Title", nil)];
    
    [self.view addSubview:_permissionTitle];
    [_permissionTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionTitle attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_iPhoneImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    _permissionDescription = [[UILabel alloc] init];
    [_permissionDescription setFont:[UIFont fontWithName:@"DINPro-Light" size:18.0]];
    [_permissionDescription setNumberOfLines:0];
    [_permissionDescription setLineBreakMode:NSLineBreakByTruncatingTail];
    [_permissionDescription setTextColor:[UIColor whiteColor]];
    [_permissionDescription setTextAlignment:NSTextAlignmentCenter];
    [_permissionDescription setText:NSLocalizedString(@"Tutorial1", nil)];
    [self.view addSubview:_permissionDescription];
    [_permissionDescription setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionDescription attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionDescription attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_iPhoneImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_iPhoneImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionDescription attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_iPhoneImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0]];
    _permissionDescription.alpha = 0.0;
    
    _permissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_permissionButton setBackgroundColor:[UIColor colorWithRed:0.01 green:0.82 blue:0.31 alpha:1]];
    [_permissionButton.titleLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:20.0]];
    [_permissionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_permissionButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [_permissionButton.layer setCornerRadius:5.0];
    [_permissionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_permissionButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.75/1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_iPhoneImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_permissionButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0]];
    _permissionButton.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    iPhoneXPosition.constant = -100.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _permissionDescription.alpha = 1.0f;
        _permissionButton.alpha = 1.0f;
    } completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UINavigationController Delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
