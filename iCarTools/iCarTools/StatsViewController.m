//
//  StatsViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 12.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController () {
    NSArray *responseArray;
    CLLocationCoordinate2D userCoordinate;
    CLLocationCoordinate2D stationCoordinate;
    UIGestureRecognizer *tapper;
    int kompasPosition;
}

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    [self.gpsUtilities startGPS];
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView.userLocation setTitle:NSLocalizedString(@"currentLocation", nil)];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mapType"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"MKMapTypeStandard" forKey:@"mapType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"mapType"]  isEqual: @"MKMapTypeSatellite"]) {
        [self satelliteMap];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"mapType"]  isEqual: @"MKMapTypeHybrid"]) {
        [self hybridMap];
    } else {
        [self standardMap];
    }
    
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
    [self.mapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.navigationController.navigationBar.hidden = YES;
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    [self updateDataSourceInLeftRevealViewController];
    
    [self setFramesForInterface:self.interfaceOrientation];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showAnnotations"];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [((SettingsViewController *)self.revealViewController.rearViewController) setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setFramesForInterface:self.interfaceOrientation];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"zoom"] == YES) {
        @try{
            [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
        }@catch(id anException){
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"zoom"];
        [self zoomStation];
    }
}

- (id<UILayoutSupport>)topLayoutGuide {
    
    if ((self.interfaceOrientation == UIInterfaceOrientationUnknown) || (self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return [[FixedCompassLayout alloc]initWithLength:44];
    } else {
        return [[FixedCompassLayout alloc]initWithLength:0];
    }
}

- (id<UILayoutSupport>)bottomLayoutGuide {
    
    if ((self.interfaceOrientation == UIInterfaceOrientationUnknown) || (self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return [[FixedCompassLayout alloc]initWithLength:44];
    } else {
        return [[FixedCompassLayout alloc]initWithLength:0];
    }
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
        
        NSString *companyOfStation;
        
        if ([annotation.title rangeOfString:@"shell" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            companyOfStation = @"shell";
        } else if ([annotation.title rangeOfString:@"bp" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            companyOfStation = @"bp";
        } else if ([annotation.title rangeOfString:@"lotos" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            companyOfStation = @"lotos";
        } else if ([annotation.title rangeOfString:@"orlen" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            companyOfStation = @"orlen";
        } else if ([annotation.title rangeOfString:@"statoil" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            companyOfStation = @"statoil";
        } else if ([annotation.title rangeOfString:@"lukoil" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            companyOfStation = @"lukoil";
        } else {
            companyOfStation = @"gas";
        }

        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:companyOfStation];
        
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
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogged"] == [NSNumber numberWithBool:YES]) {
        
        if (_addStationView) {
            //        _statsView.delegate = nil;
            _addStationView = nil;
        }
    
        _addStationView = [[AddStationViewController alloc] initWithNibName:@"AddStationViewController" bundle:nil];
        //    _statsView.delegate = self;
        _addStationView.parentView = self;
        _addStationView.wantsCustomAnimation = YES;
        [self.revealViewController setFrontViewController:_addStationView animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"This option is only available for logged-in users"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

- (IBAction)findStationAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setDouble:userCoordinate.latitude forKey:@"userLat"];
    [[NSUserDefaults standardUserDefaults] setDouble:userCoordinate.longitude forKey:@"userLong"];
    
    if (_searchView) {
        //        _statsView.delegate = nil;
        _searchView = nil;
    }
    
    _searchView = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    //    _statsView.delegate = self;
    _searchView.parentView = self;
    _searchView.wantsCustomAnimation = YES;
    [self.revealViewController setFrontViewController:_searchView animated:YES];
}

- (void)zoomStation {
    
    for (int i = 0; i<[responseArray count]; i++) {
        
        NSString *categoryString = nil;
        categoryString = responseArray[i][@"name"];
        stationCoordinate.latitude = [responseArray[i][@"latitude"] doubleValue];
        stationCoordinate.longitude = [responseArray[i][@"longitude"] doubleValue];
        
        if ([categoryString isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRow"]])
        {
            MKCoordinateRegion region;
            region.center.latitude = stationCoordinate.latitude;
            region.center.longitude = stationCoordinate.longitude;
            MKCoordinateSpan span;
            span.latitudeDelta  = 0.01;
            span.longitudeDelta = 0.01;
            region.span = span;
            [self.mapView setRegion:region animated:NO];
            for (id<MKAnnotation> annotation in _mapView.annotations){
                if ([[annotation title] isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRow"]]){
                    [_mapView selectAnnotation:annotation animated:YES];
                }
            }
            [self.view reloadInputViews];
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
            NSString *companyOfStation;
            
            if ([categoryString rangeOfString:@"shell" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                companyOfStation = @"shell";
            } else if ([categoryString rangeOfString:@"bp" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                companyOfStation = @"bp";
            } else if ([categoryString rangeOfString:@"lotos" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                companyOfStation = @"lotos";
            } else if ([categoryString rangeOfString:@"orlen" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                companyOfStation = @"orlen";
            } else if ([categoryString rangeOfString:@"statoil" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                companyOfStation = @"statoil";
            } else if ([categoryString rangeOfString:@"lukoil" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                companyOfStation = @"lukoil";
            } else {
                companyOfStation = @"gas";
            }
            annotation = [[MyCustomAnnotation alloc] initWithTitle:categoryString Subtitle:subtitle Location:stationCoordinate Company:companyOfStation];
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

    } else if (control == view.rightCalloutAccessoryView) {

        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogged"] == [NSNumber numberWithBool:YES]) {

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
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"This option is only available for logged-in users"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }

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
        [self.mapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.upperBackgroundView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [self.lowerBackgroundView setFrame:CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width, 55)];
        [self.menuButton setFrame:CGRectMake(10, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.exitButton setFrame:CGRectMake(self.upperBackgroundView.frame.size.width-34, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.findStationButton setFrame:CGRectMake((self.view.frame.size.width-75)/2, self.view.frame.size.height-10-35, 50, 50)];
        [self.findStationButton setCenter:self.lowerBackgroundView.center];
        [self.addStationButton setFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+3, 35, 35)];
        [self.addStationButton setCenter:CGPointMake(self.findStationButton.center.x*1.5+8, self.addStationButton.center.y+4)];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.lowerBackgroundView.frame.origin.y+5, 32, 32)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.findStationButton.center.x/2-8, self.gpsStatusImageView.center.y+4)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView setFrame:CGRectMake(44, 0, self.view.frame.size.width-99, self.view.frame.size.height)];
        [self.upperBackgroundView setFrame:CGRectMake(0, 0, 44, self.view.frame.size.height)];
        [self.lowerBackgroundView setFrame:CGRectMake(self.view.frame.size.width-55, 0, 55, self.view.frame.size.height)];
        [self.menuButton setFrame:CGRectMake(5, 10, 34, 34)];
        [self.exitButton setFrame:CGRectMake(5, self.view.frame.size.height-55, 34, 34)];
        [self.findStationButton setFrame:CGRectMake(self.view.frame.size.width-10-35, (self.view.frame.size.height-75)/2, 50, 50)];
        [self.findStationButton setCenter:self.lowerBackgroundView.center];
        
        [self.addStationButton setFrame:CGRectMake(0, 0, 35, 35)];
        [self.addStationButton setCenter:CGPointMake(self.lowerBackgroundView.center.x, self.findStationButton.frame.origin.y + self.findStationButton.frame.size.height + (self.lowerBackgroundView.frame.origin.y - self.findStationButton.frame.origin.y - self.findStationButton.frame.size.height)/2.0-20)];
        
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height + (self.findStationButton.frame.origin.y - (self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height))/2.0, 32, 32)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.lowerBackgroundView.center.x, self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height + (self.findStationButton.frame.origin.y - (self.lowerBackgroundView.frame.origin.y + self.lowerBackgroundView.frame.size.height))/2.0+20)];
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
        for (id<MKAnnotation> annotation in _mapView.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
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
- (void)clickedOption:(int)number inMenuType:(int)menuType {
    
    if (menuType == 0) {
        switch (number) {
            case 0:
                [self standardMap];
                break;
            case 1:
                [self hybridMap];
                break;
            case 2:
                [self satelliteMap];
                break;
                
            default:
                break;
        }
        [self.mapView reloadInputViews];
    }
}

- (void)standardMap {
    [[NSUserDefaults standardUserDefaults] setObject:@"MKMapTypeStandard" forKey:@"mapType"];
    self.mapView.mapType = MKMapTypeStandard;
}

- (void)hybridMap {
    [[NSUserDefaults standardUserDefaults] setObject:@"MKMapTypeHybrid" forKey:@"mapType"];
    self.mapView.mapType = MKMapTypeHybrid;
}

- (void)satelliteMap {
    [[NSUserDefaults standardUserDefaults] setObject:@"MKMapTypeSatellite" forKey:@"mapType"];
    self.mapView.mapType = MKMapTypeSatellite;
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
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [((SettingsViewController *)self.revealViewController.rearViewController) setDelegate:nil];
}

@end
