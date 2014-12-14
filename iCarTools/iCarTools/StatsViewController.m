//
//  StatsViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 12.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    
    self.mapView.mapType = 3;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView.userLocation setTitle:NSLocalizedString(@"currentLocation", nil)];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:NULL];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    if (!self.upperBackgroundView) {
        self.upperBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [self.upperBackgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:59.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [self.upperBackgroundView setAlpha:0.9];
    }
    
    if (![self.upperBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.upperBackgroundView];
    }
    
    if (!self.lowerBackgroundView) {
        self.lowerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-95, self.view.frame.size.width, 95)];
        [self.lowerBackgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:59.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [self.lowerBackgroundView setAlpha:0.9];
    }
    
    if (![self.lowerBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.lowerBackgroundView];
    }
    
    if (!self.menuButton) {
        self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, self.menuButton.frame.size.height-10)];
        [self.menuButton setImage:[UIImage imageNamed:@"menu-128"] forState:UIControlStateNormal];  }
    
    if (![self.menuButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.menuButton];
    }

    if (!self.exitButton) {
        self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.upperBackgroundView.frame.size.width-34, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.exitButton setImage:[UIImage imageNamed:@"exit-50"] forState:UIControlStateNormal];  }
    
    if (![self.exitButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.exitButton];
    }
    
    [self.exitButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.findStationButton) {
        self.findStationButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-75)/2, self.view.frame.size.height-10-75, 75, 75)];
        [self.findStationButton setBackgroundColor:[UIColor clearColor]];
        [self.findStationButton setImage:[UIImage imageNamed:@"search-256"] forState:UIControlStateNormal];
        [self.findStationButton setUserInteractionEnabled:YES];
        
    }
    
    if (![self.findStationButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.findStationButton];
    }
  
    if (!self.addStationButton) {
        self.addStationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+15, 50, 50)];
        [self.addStationButton setCenter:CGPointMake(self.findStationButton.center.x*1.5+8, self.addStationButton.center.y+4)];
        [self.addStationButton setImage:[UIImage imageNamed:@"plus-128"] forState:UIControlStateNormal];
        [self.view addSubview:self.addStationButton];
    }
    
    if (!self.gpsStatusImageView) {
        self.gpsStatusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps_searching-256"]];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.lowerBackgroundView.frame.origin.y+15, 47, 47)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.findStationButton.center.x/2-8, self.gpsStatusImageView.center.y+4)];
        [self.view addSubview:self.gpsStatusImageView];
    }

    self.navigationController.navigationBar.hidden = YES;
    
    [self updateDataSourceInLeftRevealViewController];
    
    [self setFramesForInterface:self.interfaceOrientation];
}

- (void)updateDataSourceInLeftRevealViewController {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[@"Settings", @"Map type"]];
    }
}

/**
 *  @Author Damian Klimaszewski
 *
 *  Set observer for user location
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.1;
    span.longitudeDelta = 0.1;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch * touch in touches) {
        CGPoint loc = [touch locationInView:self.mapView];
        if ([self.mapView pointInside:loc withEvent:event]) {
            @try{
                [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
            }@catch(id anException){
            }
            break;
        }
    }
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
        [self.upperBackgroundView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [self.lowerBackgroundView setFrame:CGRectMake(0, self.view.frame.size.height-95, self.view.frame.size.width, 95)];
        [self.menuButton setFrame:CGRectMake(10, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.exitButton setFrame:CGRectMake(self.upperBackgroundView.frame.size.width-34, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.findStationButton setFrame:CGRectMake((self.view.frame.size.width-75)/2, self.view.frame.size.height-10-75, 75, 75)];
        [self.findStationButton setCenter:self.lowerBackgroundView.center];
        [self.addStationButton setFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+15, 50, 50)];
        [self.addStationButton setCenter:CGPointMake(self.findStationButton.center.x*1.5+8, self.addStationButton.center.y+4)];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.lowerBackgroundView.frame.origin.y+15, 47, 47)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.findStationButton.center.x/2-8, self.gpsStatusImageView.center.y+4)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.upperBackgroundView setFrame:CGRectMake(0, 0, 44, self.view.frame.size.height)];
        [self.lowerBackgroundView setFrame:CGRectMake(self.view.frame.size.width-95, 0, 95, self.view.frame.size.height)];
        [self.menuButton setFrame:CGRectMake(5, 10, 34, 34)];
        [self.exitButton setFrame:CGRectMake(5, self.view.frame.size.height-55, 34, 34)];
        [self.findStationButton setFrame:CGRectMake(self.view.frame.size.width-10-75, (self.view.frame.size.height-75)/2, 75, 75)];
        [self.findStationButton setCenter:self.lowerBackgroundView.center];
        
        [self.addStationButton setFrame:CGRectMake(0, 0, 50, 50)];
        [self.addStationButton setCenter:CGPointMake(self.lowerBackgroundView.center.x, self.findStationButton.frame.origin.y + self.findStationButton.frame.size.height + (self.lowerBackgroundView.frame.origin.y - self.findStationButton.frame.origin.y - self.findStationButton.frame.size.height)/2.0-20)];
        
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height + (self.findStationButton.frame.origin.y - (self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height))/2.0, 47, 47)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.lowerBackgroundView.center.x, self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height + (self.findStationButton.frame.origin.y - (self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height))/2.0+20)];
    });
}

- (void)setFramesForLandscapeRight {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.upperBackgroundView setFrame:CGRectMake(self.view.frame.size.width-44, 0, 44, self.view.frame.size.height)];
        [self.lowerBackgroundView setFrame:CGRectMake(0, 0, 95, self.view.frame.size.height)];
        [self.menuButton setFrame:CGRectMake(0, 10, 44, 44)];
        [self.exitButton setFrame:CGRectMake(self.upperBackgroundView.center.x, 0, 44, 44)];
        [self.findStationButton setFrame:CGRectMake(10, (self.view.frame.size.height-75)/2, 75, 75)];
        [self.findStationButton setCenter:self.lowerBackgroundView.center];
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)mapType {
}

- (void)locationUpdate:(CLLocation *)location {
    NSLog(@"New Location: %@", location);
}

- (void)locationError:(NSError *)error {
    NSLog(@"Location error: %@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    self.gpsUtilities.delegate = nil;
    self.gpsUtilities = nil;
}

- (void)exit {
    @try{
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }@catch(id anException){
    }

    [self.gpsUtilities stopGPS];
    [self.revealViewController pushFrontViewController:_parentView animated:YES];
    _parentView = nil;
}

@end
