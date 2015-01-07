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

/**
 *  @author Damian Klimaszewski
 *
 *  Przycisk powrotu do poprzedniego widoku
 *
 */
- (IBAction)backButtonAction:(id)sender;

/**
 *  @author Damian Klimaszewski
 *
 *   Widok, z którego został uruchomiony PricesViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@end
