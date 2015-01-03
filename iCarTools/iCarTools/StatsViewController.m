//
//  StatsViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 12.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController () {
    int menuType;
    NSArray *responseArray;
    CLLocationCoordinate2D userCoordinate;
    CLLocationCoordinate2D stationCoordinate;
    UIGestureRecognizer *tapper;
}

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    [self.gpsUtilities startGPS];
    
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
    
    [self.menuButton removeTarget:[self revealViewController] action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton addTarget:[self revealViewController] action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

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
    
    [self.findStationButton removeTarget:self action:@selector(findStationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.findStationButton addTarget:self action:@selector(findStationAction:) forControlEvents:UIControlEventTouchUpInside];
  
    if (!self.addStationButton) {
        self.addStationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+15, 50, 50)];
        [self.addStationButton setCenter:CGPointMake(self.findStationButton.center.x*1.5+8, self.addStationButton.center.y+4)];
        [self.addStationButton setImage:[UIImage imageNamed:@"plus-128"] forState:UIControlStateNormal];
        [self.view addSubview:self.addStationButton];
    }
    
    [self.addStationButton removeTarget:self action:@selector(addStationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addStationButton addTarget:self action:@selector(addStationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.gpsStatusImageView) {
        self.gpsStatusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps_searching-256"]];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.lowerBackgroundView.frame.origin.y+15, 47, 47)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.findStationButton.center.x/2-8, self.gpsStatusImageView.center.y+4)];
        [self.view addSubview:self.gpsStatusImageView];
    }
    
    if (!self.searchBar) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-9, 44, self.mapView.frame.size.width+20, 25)];
        [self.searchBar setBackgroundImage:[UIImage new]];
    }
    
    if (![self.searchBar isDescendantOfView:self.view]) {
        [self.view addSubview:self.searchBar];
        self.searchBar.hidden = YES;
    }
    
    self.navigationController.navigationBar.hidden = YES;
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    self.searchBar.delegate = self;
    
    [self updateDataSourceInLeftRevealViewController];
    
    [self setFramesForInterface:self.interfaceOrientation];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showAnnotations"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setFramesForInterface:self.interfaceOrientation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.navigationController.navigationBar endEditing:YES];
}

/**
 *  @Author Damian Klimaszewski
 *
 *  Left menu
 */
- (void)updateDataSourceInLeftRevealViewController {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[
                                                                                                              NSLocalizedString(@"normal", nil),
                                                                                                              NSLocalizedString(@"hybrid", nil),
                                                                                                              NSLocalizedString(@"satellite", nil)]
                                                                                                andMenuType:0];
    }
}

-(void)addAnnotation {
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/getStationList.php?latitude=%f&longitude=%f&diff=%f",userCoordinate.latitude,userCoordinate.longitude,0.5]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MyCustomAnnotation class]]) {
        
        MyCustomAnnotation *myLocation = (MyCustomAnnotation *)annotation;
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if(annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        
        return annotationView;
    }
    else
        return nil;
}

- (IBAction)addStationAction:(id)sender {
    if (_addStationView) {
        //        _statsView.delegate = nil;
        _addStationView = nil;
    }
    
    _addStationView = [[AddStationViewController alloc] initWithNibName:@"AddStationViewController" bundle:nil];
    //    _statsView.delegate = self;
    _addStationView.parentView = self;
    _addStationView.wantsCustomAnimation = YES;
    [self.revealViewController setFrontViewController:_addStationView animated:YES];
    
    self.searchBar.hidden = YES;
}

- (IBAction)findStationAction:(id)sender {

    if (self.searchBar.hidden == YES) {
        self.searchBar.hidden = NO;
    }
    else {
        self.searchBar.hidden = YES;
    }
    @try{
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }@catch(id anException){
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    for (int i = 0; i<[responseArray count]; i++) {
        
        NSString *categoryString = nil;
        categoryString = responseArray[i][@"name"];
        stationCoordinate.latitude = [responseArray[i][@"latitude"] doubleValue];
        stationCoordinate.longitude = [responseArray[i][@"longitude"] doubleValue];
        NSString *subtitle = responseArray[i][@"address"];
        
        if ([categoryString containsString:[self.searchBar text]])
        {
            MKCoordinateRegion region;
            region.center.latitude = stationCoordinate.latitude;
            region.center.longitude = stationCoordinate.longitude;
            MKCoordinateSpan span;
            span.latitudeDelta  = 0.01;
            span.longitudeDelta = 0.01;
            region.span = span;
            
            for (id<MKAnnotation> annotation in _mapView.annotations){
                if ([[annotation title] containsString:[self.searchBar text]]){
                    [_mapView selectAnnotation:annotation animated:YES];
                    
                }
            }
            [self.mapView setRegion:region animated:YES];
            [self.mapView reloadInputViews];
        }
        else if ([subtitle containsString:[self.searchBar text]])
        {
            MKCoordinateRegion region;
            region.center.latitude = stationCoordinate.latitude;
            region.center.longitude = stationCoordinate.longitude;
            MKCoordinateSpan span;
            span.latitudeDelta  = 0.01;
            span.longitudeDelta = 0.01;
            region.span = span;
            
            for (id<MKAnnotation> annotation in _mapView.annotations){
                if ([[annotation subtitle] containsString:[self.searchBar text]]){
                    [_mapView selectAnnotation:annotation animated:YES];
                    
                }
            }
            [self.mapView setRegion:region animated:YES];
            [self.mapView reloadInputViews];
        }
    }
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    NSLog(@"response: %@", responseDict);
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    
    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        
        if (responseArray) {
            responseArray = nil;
        }
        responseArray = [responseDict objectForKey:@"response"];
        
        for (int i = 0; i<[responseArray count]; i++) {
      
            MyCustomAnnotation *annotation = nil;
            NSString *categoryString = nil;
            categoryString = responseArray[i][@"name"];
            stationCoordinate.latitude = [responseArray[i][@"latitude"] doubleValue];
            stationCoordinate.longitude = [responseArray[i][@"longitude"] doubleValue];
            NSString *subtitle = responseArray[i][@"address"];
            annotation = [[MyCustomAnnotation alloc] initWithTitle:categoryString Subtitle:subtitle Location:stationCoordinate];
            [self.mapView addAnnotation:annotation];
        }
        //responseArray = nil;
    }
}

/**
 *  @Author Damian Klimaszewski
 *
 *  Actions in annotations
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
    calloutAccessoryControlTapped:(UIControl *)control {
    
    if (control == view.leftCalloutAccessoryView) {
        
        if (_pricesView) {
            //        _statsView.delegate = nil;
            _pricesView = nil;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:view.annotation.title forKey:@"stationName"];
        
        _pricesView = [[PricesViewController alloc] initWithNibName:@"PricesViewController" bundle:nil];
        //    _statsView.delegate = self;
        _pricesView.parentView = self;
        _pricesView.wantsCustomAnimation = YES;
        [self.revealViewController setFrontViewController:_pricesView animated:YES];
        self.searchBar.hidden = YES;

    } else if (control == view.rightCalloutAccessoryView) {

        [[NSUserDefaults standardUserDefaults] setObject:view.annotation.title forKey:@"stationName"];
        [[NSUserDefaults standardUserDefaults] setObject:view.annotation.subtitle forKey:@"stationAddress"];

        if (_changeStationView) {
            //        _statsView.delegate = nil;
            _changeStationView = nil;
        }
    
        _changeStationView = [[ChangeViewController alloc] initWithNibName:@"ChangeViewController" bundle:nil];
        //    _statsView.delegate = self;
        _changeStationView.parentView = self;
        _changeStationView.wantsCustomAnimation = YES;
        [self.revealViewController setFrontViewController:_changeStationView animated:YES];
    
        self.searchBar.hidden = YES;
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
    span.latitudeDelta  = 0.01;
    span.longitudeDelta = 0.01;
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
    
    if (self.searchBar.hidden == NO) {
        self.searchBar.hidden = YES;
    }
    [self.view endEditing:YES];
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
        [self.searchBar setFrame:CGRectMake(-9, 44, self.mapView.frame.size.width+20, 25)];
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
        
        [self.searchBar setFrame:CGRectMake(36, 0, self.mapView.frame.size.width-44-79, 25)];
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)gpsDidChangeState:(int)state {
    
    self.gpsStatusImageView.image = nil;
    if (state == 2) {
        self.gpsStatusImageView.image = [UIImage imageNamed:@"gps_receiving-256"];
    } else if (state == 1) {
        self.gpsStatusImageView.image = [UIImage imageNamed:@"gps_searching-256"];
    } else {
        self.gpsStatusImageView.image = [UIImage imageNamed:@"gps_disconnected-256"];
    }
    
}

- (void)locationUpdate:(CLLocation *)location {
    userCoordinate.latitude = location.coordinate.latitude;
    userCoordinate.longitude = location.coordinate.longitude;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showAnnotations"]) {
        [self addAnnotation];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showAnnotations"];
    }
    
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

#pragma mark- StatsViewController
- (void)clickedOption:(int)number {
    
    if (menuType == 0) {
        switch (number) {
            case 0:
                self.mapView.mapType = MKMapTypeStandard;
                break;
            case 1:
                self.mapView.mapType = MKMapTypeHybrid;
                break;
            case 2:
                self.mapView.mapType = MKMapTypeSatellite;
                break;
                
            default:
                break;
        }
        [self.mapView reloadInputViews];
    }
}
#pragma mark- Update After Settings Changes

- (void)dealloc {
    [self exit];
}

- (void)exit {
    @try{
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }@catch(id anException){
    }

    [self.gpsUtilities stopGPS];
    self.gpsUtilities.delegate = nil;
    self.gpsUtilities = nil;
//    [self.revealViewController pushFrontViewController:_parentView animated:YES];
    [self.revealViewController setFrontViewController:_parentView animated:YES];
    _parentView = nil;
    self.searchBar = nil;
}

@end
