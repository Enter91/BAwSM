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

@import AVFoundation;
@import AssetsLibrary;
@import MobileCoreServices;

#import "LoginViewController.h"
#import <SWRevealViewController.h>
#import "SettingsViewController.h"

@protocol StatsViewControllerDelegate <NSObject>

- (void)statsViewWantsDismiss;

@end

@interface StatsViewController : UIViewController <GPSUtilitiesDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) GPSUtilities *gpsUtilities;

@property (strong, nonatomic) UIView *upperBackgroundView;
@property (strong, nonatomic) UIView *lowerBackgroundView;

@property (strong, nonatomic) UIImageView *gpsStatusImageView;

@property (strong, nonatomic) UIButton *exitButton;

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) UIViewController *parentView;

@end
