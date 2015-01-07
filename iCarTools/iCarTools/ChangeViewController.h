//
//  ChangeViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 17.12.2014.
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

@interface ChangeViewController : UIViewController <UITextFieldDelegate, AmazingJSONDelegate, GPSUtilitiesDelegate, AmazingJSONDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *pb95Label;
@property (weak, nonatomic) IBOutlet UILabel *pb98Label;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;
@property (weak, nonatomic) IBOutlet UILabel *lpgLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UITextField *stationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *pb95TextField;
@property (weak, nonatomic) IBOutlet UITextField *pb98TextField;
@property (weak, nonatomic) IBOutlet UITextField *onTextField;
@property (weak, nonatomic) IBOutlet UITextField *lpgTextField;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/**
 *  @author Damian Klimaszewski
 *
 *  Zapis wizyty na stacji do bazy
 */
- (IBAction)saveAction:(id)sender;

/**
 *  @author Damian Klimaszewski
 *
 *  Anulowanie dodania wizyty
 */
- (IBAction)cancelAction:(id)sender;

/**
 *  @author Damian Klimaszewski
 *
 *  Widok, z którego został uruchomiony ChangeViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@end
