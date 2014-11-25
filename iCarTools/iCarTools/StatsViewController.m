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
        
        [self.upperBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.upperBackgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.upperBackgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.upperBackgroundView attribute:NSLayoutAttributeHeight multiplier:320.0/44.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.upperBackgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.upperBackgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.upperBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    }
    
    if (!self.exitButton) {
        self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, self.upperBackgroundView.frame.size.height)];
        [self.exitButton setTitle:NSLocalizedString(@"BACK", nil) forState:UIControlStateNormal];
    }
    
    if (![self.exitButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.exitButton];
        
        [self.exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.exitButton addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.exitButton attribute:NSLayoutAttributeHeight multiplier:50.0/44.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.upperBackgroundView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.upperBackgroundView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.upperBackgroundView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    }
    
    [self.exitButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.lowerBackgroundView) {
        self.lowerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-65, self.view.frame.size.width, 65)];
        [self.lowerBackgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:59.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [self.lowerBackgroundView setAlpha:0.9];
    }
    
    if (![self.lowerBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.lowerBackgroundView];
        
        [self.lowerBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.lowerBackgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerBackgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.lowerBackgroundView attribute:NSLayoutAttributeHeight multiplier:320.0/65.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerBackgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerBackgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerBackgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

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

- (void)locationUpdate:(CLLocation *)location {
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

- (void)exit {
    @try{
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }@catch(id anException){
    }

    [self.revealViewController pushFrontViewController:_parentView animated:YES];
    _parentView = nil;
}

@end
