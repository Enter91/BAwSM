//
//  PricesViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 30.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>
#import "AmazingJSON.h"
#import "GPSUtilities.h"
#import "SettingsViewController.h"

@import AVFoundation;
@import AssetsLibrary;
@import MobileCoreServices;

@interface PricesViewController : UIViewController <UITextFieldDelegate, AmazingJSONDelegate, AmazingJSONDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backButtonAction:(id)sender;

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) GPSUtilities *gpsUtilities;

@property (nonatomic, strong) UIViewController *parentView;

@property (nonatomic) BOOL wantsCustomAnimation;

@end
