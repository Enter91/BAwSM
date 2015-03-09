//
//  ViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block UIImageView *launch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CustomLaunch"]];
    [launch setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:launch];
    
    [UIView animateWithDuration:0.5 animations:^{
        launch.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        launch.alpha = 0.0;
    } completion:^(BOOL finished) {
        [launch removeFromSuperview];
        launch = nil;
    }];
    
    
    
    _wantsCustomAnimation = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController setDelegate:self];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.statsOpenButton setTitle:NSLocalizedString(@"stats", nil) forState:UIControlStateNormal];
    [self.videoRecorderOpenButton setTitle:NSLocalizedString(@"recorder", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    
    [self setFramesForInterface:self.interfaceOrientation];
    self.revealViewController.tapGestureRecognizer.enabled = YES;
    self.revealViewController.panGestureRecognizer.enabled = YES;
    
    [self.settingsOpenButton setTitle:NSLocalizedString(@"about", nil) forState:UIControlStateNormal];
    
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[NSLocalizedString(@"copyright", nil),NSLocalizedString(@"authors", nil),NSLocalizedString(@"reserved", nil)] andMenuType:0];
    }
    
    if (_recorderView) {
        _recorderView = nil;
    }
    
    if (_statsView) {
        _statsView = nil;
    }
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Obsługa RecorderViewController
- (IBAction)videoRecorderOpenAction:(id)sender {
    if (_recorderView) {
        _recorderView = nil;
    }
    
    _recorderView = [[RecorderViewController alloc] initWithNibName:@"RecorderViewController" bundle:nil];
//    _recorderView.parentView = self;
    _recorderView.wantsCustomAnimation = YES;
    [self.revealViewController setFrontViewController:_recorderView animated:YES];
}

#pragma mark- Obsługa StatsViewController
- (IBAction)statsOpenAction:(id)sender {
    if (_statsView) {
        _statsView = nil;
    }
    
    _statsView = [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil];
    _statsView.parentView = self;
    _statsView.wantsCustomAnimation = YES;
    [self.revealViewController setFrontViewController:_statsView animated:YES];
}


- (IBAction)settingsOpenAction:(id)sender {
    [self.revealViewController revealToggle:nil];
}

#pragma mark- Helpers
- (void)showAllFontsProvidedByApplication {
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

#pragma mark- UINavigationController Delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setFramesForInterface:(UIInterfaceOrientation)toInterfaceOrientation {
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationPortrait:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self setFramesForLandscapeLeft];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self setFramesForLandscapeLeft];
            break;
        default:
            break;
    }
}

- (void)setFramesForPortrait {
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            [_titleLabel setFont:[UIFont fontWithName:@"BrannbollFet" size:45]];
        }
        
        float offsetY = 30;
        [_backgroundImageview setFrame:CGRectMake(0, 0, 320, 568)];
        [_titleLabel setFrame:CGRectMake(16, 50, 288, 110)];
        [_videoRecorderOpenButton setFrame:CGRectMake(100, 201+offsetY, 250, 38)];
        [_videoRecorderOpenImageButton setFrame:CGRectMake(20, 190+offsetY, 60, 60)];
        [_videoImage setFrame:CGRectMake(20, 190+offsetY, 60, 60)];
        [_statsOpenButton setFrame:CGRectMake(100, 281+offsetY, 250, 38)];
        [_statsOpenImageButton setFrame:CGRectMake(20, 270+offsetY, 60, 60)];
        [_statsImage setFrame:CGRectMake(20, 270+offsetY, 60, 60)];
        [_settingsOpenButton setFrame:CGRectMake(100, 361+offsetY, 250, 38)];
        [_settingsOpenImageButton setFrame:CGRectMake(20, 350+offsetY, 60, 60)];
        [_settingsImage setFrame:CGRectMake(20, 350+offsetY, 60, 60)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            [_titleLabel setFont:[UIFont fontWithName:@"BrannbollFet" size:25]];
        }
        [_backgroundImageview setFrame:CGRectMake(0, 0, 568, 320)];
        [_titleLabel setFrame:CGRectMake(150, 10, 288, 60)];
        [_videoRecorderOpenButton setFrame:CGRectMake(240, 101, 250, 38)];
        [_videoRecorderOpenImageButton setFrame:CGRectMake(160, 90, 60, 60)];
        [_videoImage setFrame:CGRectMake(160, 90, 60, 60)];
        [_statsOpenButton setFrame:CGRectMake(240, 181, 250, 38)];
        [_statsOpenImageButton setFrame:CGRectMake(160, 170, 60, 60)];
        [_statsImage setFrame:CGRectMake(160, 170, 60, 60)];
        [_settingsOpenButton setFrame:CGRectMake(240, 261, 250, 38)];
        [_settingsOpenImageButton setFrame:CGRectMake(160, 250, 60, 60)];
        [_settingsImage setFrame:CGRectMake(160, 250, 60, 60)];
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

#pragma mark - SWRevealViewDelegate

- (id <UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ( operation != SWRevealControllerOperationReplaceFrontController )
        return nil;
    
    if ( [toVC isKindOfClass:[RecorderViewController class]] )
    {
        if ( [(RecorderViewController*)toVC wantsCustomAnimation] )
        {
            id<UIViewControllerAnimatedTransitioning> animationController = [[CustomAnimationController alloc] init];
            return animationController;
        }
    }
    
    if ( [toVC isKindOfClass:[StatsViewController class]] )
    {
        if ( [(StatsViewController*)toVC wantsCustomAnimation] )
        {
            id<UIViewControllerAnimatedTransitioning> animationController = [[CustomAnimationController alloc] init];
            return animationController;
        }
    }
    
    if ( [toVC isKindOfClass:[ViewController class]] )
    {
        if ( [(ViewController*)toVC wantsCustomAnimation] )
        {
            id<UIViewControllerAnimatedTransitioning> animationController = [[CustomAnimationController alloc] init];
            return animationController;
        }
    }
    
    return nil;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}

@end
