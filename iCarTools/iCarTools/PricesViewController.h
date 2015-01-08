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

/*!
 * @author Damian Klimaszewski
 * @discussion Klasa widoku cen w bazie
 */
@interface PricesViewController : UIViewController <UITextFieldDelegate, AmazingJSONDelegate, AmazingJSONDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

/*!
 * @author Damian Klimaszewski
 * @discussion Widok tabeli
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk powrotu
 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Przycisk powrotu do poprzedniego widoku
 *  @param  sender Obiekt wywołujący akcję
 */
- (IBAction)backButtonAction:(id)sender;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok, z którego został uruchomiony PricesViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@end
