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
    
    _wantsCustomAnimation = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController setDelegate:self];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.statsOpenButton setTitle:NSLocalizedString(@"stats", nil) forState:UIControlStateNormal];
    [self.videoRecorderOpenButton setTitle:NSLocalizedString(@"recorder", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[
                                                                                            NSLocalizedString(@"About", nil)]
                                                                                                andMenuType:0];
    }
    
    if (_recorderView) {
//        [_recorderView setDelegate:nil];
        _recorderView = nil;
    }
    
    if (_statsView) {
//        [_statsView setDelegate:nil];
        _statsView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Obsługa RecorderViewController
- (IBAction)videoRecorderOpenAction:(id)sender {
    if (_recorderView) {
//        _recorderView.delegate = nil;
        _recorderView = nil;
    }
    
    _recorderView = [[RecorderViewController alloc] initWithNibName:@"RecorderViewController" bundle:nil];
//    _recorderView.delegate = self;
    _recorderView.parentView = self;
    _recorderView.wantsCustomAnimation = YES;
    [self.revealViewController setFrontViewController:_recorderView animated:YES];
}

#pragma mark- Obsługa StatsViewController
- (IBAction)statsOpenAction:(id)sender {
    if (_statsView) {
//        _statsView.delegate = nil;
        _statsView = nil;
    }
    
    _statsView = [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil];
//    _statsView.delegate = self;
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
@end
