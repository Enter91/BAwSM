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
    
    [self.statsOpenButton setTitle:NSLocalizedString(@"stats", nil) forState:UIControlStateNormal];
    [self.videoRecorderOpenButton setTitle:NSLocalizedString(@"recorder", nil) forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Obsługa RecorderViewController
- (IBAction)videoRecorderOpenAction:(id)sender {
    if (_recorderView) {
        _recorderView.delegate = nil;
        _recorderView = nil;
    }
    
    _recorderView = [[RecorderViewController alloc] initWithNibName:@"RecorderViewController" bundle:nil];
    _recorderView.delegate = self;
    [self presentViewController:_recorderView animated:YES completion:nil];
}

- (void)recorderViewWantsDismiss {
    [_recorderView dismissViewControllerAnimated:YES completion:^{
        _recorderView.delegate = nil;
        _recorderView = nil;
    }];
}

#pragma mark- Obsługa StatsViewController
- (IBAction)statsOpenAction:(id)sender {
    if (_statsView) {
        _statsView.delegate = nil;
        _statsView = nil;
    }
    
    _statsView = [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil];
    _statsView.delegate = self;
    [self presentViewController:_statsView animated:YES completion:nil];
    
    //NSURL *url = [NSURL URLWithString:@"http://maps.apple.com/maps?q=Szczecin"];
    //[[UIApplication sharedApplication] openURL:url];
}

- (void)statsViewWantsDismiss {
    [_statsView dismissViewControllerAnimated:YES completion:^{
        _statsView.delegate = nil;
        _statsView = nil;
    }];
}

- (IBAction)settingsOpenAction:(id)sender {
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
@end
