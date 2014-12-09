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
    
    if (!_whiteLine1) {
        _whiteLine1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white line" ofType:@"png"]]];
        [_whiteLine1 setFrame:CGRectMake(10, self.view.frame.size.height-46-2, (self.view.frame.size.width-75.0)/2-20, _whiteLine1.frame.size.height/2)];
        [self.view addSubview:_whiteLine1];
    }
    
    if (!_whiteLine2) {
        _whiteLine2 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white line" ofType:@"png"]]];
        [_whiteLine2 setFrame:CGRectMake(self.view.frame.size.width-((self.view.frame.size.width-75.0)/2-10), self.view.frame.size.height-46-2, (self.view.frame.size.width-75.0)/2-20, _whiteLine2.frame.size.height/2)];
        [self.view addSubview:_whiteLine2];
    }
    
    if (!self.speedLabel) {
        self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-47-48, 73, 48)];
        [self.speedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:40]];
        [self.speedLabel setTextAlignment:NSTextAlignmentRight];
        [self.speedLabel setTextColor:[UIColor whiteColor]];
        [self.speedLabel setText:@"0"];
        [self.view addSubview:self.speedLabel];
    }
    
    if (!self.speedUnitsLabel) {
        self.speedUnitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.view.frame.size.height-68-27, 25, 27)];
        [self.speedUnitsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
        [self.speedUnitsLabel setTextAlignment:NSTextAlignmentCenter];
        [self.speedUnitsLabel setTextColor:[UIColor whiteColor]];
        [self.speedUnitsLabel setText:@"km/h"];
        [self.view addSubview:self.speedUnitsLabel];
    }

    
    if (!self.addStationButton) {
        self.addStationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+4, 37, 37)];
        [self.addStationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.addStationButton.center.y)];
        [self.addStationButton setImage:[UIImage imageNamed:@"plus-128"] forState:UIControlStateNormal];
        [self.view addSubview:self.addStationButton];
    }
    
    if (!self.mapTypeButton) {
        self.mapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.whiteLine2.frame.origin.y+6, 37, 37)];
        [self.mapTypeButton setCenter:CGPointMake(self.whiteLine2.center.x, self.mapTypeButton.center.y)];
        [self.mapTypeButton setImage:[UIImage imageNamed:@"map_marker-256"] forState:UIControlStateNormal];
        [self.view addSubview:self.mapTypeButton];
    }
    
    [self.mapTypeButton removeTarget:self action:@selector(mapType) forControlEvents:UIControlEventTouchUpInside];
    [self.mapTypeButton addTarget:self action:@selector(mapType) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.gpsStatusImageView) {
        self.gpsStatusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps_searching-256"]];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y+6, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.gpsStatusImageView.center.y)];
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
        [self.whiteLine1 setFrame:CGRectMake(10, self.lowerBackgroundView.center.y-1, (self.view.frame.size.width-75.0)/2-20, 2)];
        [self.whiteLine2 setFrame:CGRectMake(self.findStationButton.frame.origin.x + self.findStationButton.frame.size.width + 10, self.lowerBackgroundView.center.y-1, (self.view.frame.size.width-75.0)/2-20, 2)];
        [self.speedUnitsLabel setFrame:CGRectMake(self.findStationButton.center.x - 75/2.0 - 35, self.view.frame.size.height-68-27, 25, 27)];
        [self.speedLabel setFrame:CGRectMake(10, self.view.frame.size.height-47-48, self.speedUnitsLabel.frame.origin.x - 10, 48)];
        [self.addStationButton setFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+4, 37, 37)];
        [self.addStationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.addStationButton.center.y)];
        [self.mapTypeButton setFrame:CGRectMake(0, self.whiteLine2.frame.origin.y+6, 37, 37)];
        [self.mapTypeButton setCenter:CGPointMake(self.whiteLine2.center.x, self.mapTypeButton.center.y)];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y+6, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.gpsStatusImageView.center.y)];
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
        [self.whiteLine1 setFrame:CGRectMake(self.view.frame.size.width - 90, (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.whiteLine2 setFrame:CGRectMake(self.view.frame.size.width - 90, self.view.frame.size.height - (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.speedLabel setFrame:CGRectMake(self.view.frame.size.width - 85, 0, 60, self.whiteLine1.frame.origin.y)];
        [self.speedUnitsLabel setFrame:CGRectMake(self.view.frame.size.width - 25, 0, 25, 27)];
        
        [self.addStationButton setFrame:CGRectMake(0, 0, 37, 37)];
        [self.addStationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.findStationButton.frame.origin.y + self.findStationButton.frame.size.height + (self.whiteLine2.frame.origin.y - self.findStationButton.frame.origin.y - self.findStationButton.frame.size.height)/2.0)];
        
        [self.mapTypeButton setFrame:CGRectMake(0, 0, 37, 37)];
        [self.mapTypeButton setCenter:CGPointMake(self.whiteLine2.center.x, self.whiteLine2.frame.origin.y + self.whiteLine2.frame.size.height + (self.view.frame.size.height - (self.whiteLine2.frame.origin.y+self.whiteLine2.frame.size.height))/2.0)];
        
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height + (self.findStationButton.frame.origin.y - (self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height))/2.0, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height + (self.findStationButton.frame.origin.y - (self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height))/2.0)];


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
        [self.whiteLine1 setFrame:CGRectMake(5, (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.whiteLine2 setFrame:CGRectMake(5, self.view.frame.size.height - (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.speedLabel setFrame:CGRectMake(10, 0, 60, self.whiteLine1.frame.origin.y)];
        [self.speedUnitsLabel setFrame:CGRectMake(70, 0, 25, 27)];
        
        [self.addStationButton setFrame:CGRectMake(0, 0, 37, 37)];
        [self.addStationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.findStationButton.frame.origin.y + self.findStationButton.frame.size.height + (self.whiteLine2.frame.origin.y - self.findStationButton.frame.origin.y - self.findStationButton.frame.size.height)/2.0)];
        
        [self.mapTypeButton setFrame:CGRectMake(0, 0, 37, 37)];
        [self.mapTypeButton setCenter:CGPointMake(self.whiteLine2.center.x, self.whiteLine2.frame.origin.y + self.whiteLine2.frame.size.height + (self.view.frame.size.height - (self.whiteLine2.frame.origin.y+self.whiteLine2.frame.size.height))/2.0)];
        
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, 0.0, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height + (self.findStationButton.frame.origin.y - (self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height))/2.0)];
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)mapType {
}

- (void)locationUpdate:(CLLocation *)location {
    float speedInMetersPerSecond = location.speed;
    int speedInKilometersPerHour = speedInMetersPerSecond * 3600 / 1000;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (speedInKilometersPerHour >= 0) {
            [self.speedLabel setText:[NSString stringWithFormat:@"%d", speedInKilometersPerHour]];
        } else {
            [self.speedLabel setText:@"0"];
        }
    });
    
    NSLog(@"New Location: %@", location);
}

- (void)locationError:(NSError *)error {
    NSLog(@"Location error: %@", [error localizedDescription]);
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
