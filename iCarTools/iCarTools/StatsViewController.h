//
//  StatsViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 12.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GPSUtilities.h"
#import "LoginViewController.h"
#import <SWRevealViewController.h>
#import "SettingsViewController.h"
#import "MyCustomAnnotation.h"
#import "AmazingJSON.h"

@import AVFoundation;
@import AssetsLibrary;
@import MobileCoreServices;

@interface StatsViewController : UIViewController <GPSUtilitiesDelegate, MKMapViewDelegate, AmazingJSONDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UIButton *findStationButton;
@property (strong, nonatomic) UIButton *addStationButton;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *menuButton;

@property (strong, nonatomic) UISearchBar *searchBar;

- (IBAction)addStationAction:(id)sender;
- (IBAction)findStationAction:(id)sender;

@property (strong, nonatomic) GPSUtilities *gpsUtilities;

@property (strong, nonatomic) UIView *upperBackgroundView;
@property (strong, nonatomic) UIView *lowerBackgroundView;
@property (strong, nonatomic) UIView *searchBarView;

@property (strong, nonatomic) UIImageView *gpsStatusImageView;

//@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) UIViewController *parentView;

@property (nonatomic) BOOL wantsCustomAnimation;

@end
