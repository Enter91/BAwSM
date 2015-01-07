//
//  AddStationViewController.h
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

/*!
 * @author Damian Klimaszewski
 * @discussion Klasa dodawania cen do bazy
 */
@interface AddStationViewController : UIViewController <UITextFieldDelegate, AmazingJSONDelegate, GPSUtilitiesDelegate, AmazingJSONDelegate, UIAlertViewDelegate>

/*!
 * @author Damian Klimaszewski
 * @discussion Label nazwa stacji
 */
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label adres
 */
@property (weak, nonatomic) IBOutlet UILabel *addresLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label aktualna pozycja
 */
@property (weak, nonatomic) IBOutlet UILabel *actualPositionLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label cen paliw
 */
@property (weak, nonatomic) IBOutlet UILabel *pricesLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label ceny pb95
 */
@property (weak, nonatomic) IBOutlet UILabel *pb95Label;

/*!
 * @author Damian Klimaszewski
 * @discussion Label ceny pb98
 */
@property (weak, nonatomic) IBOutlet UILabel *pb98Label;

/*!
 * @author Damian Klimaszewski
 * @discussion Label ceny on
 */
@property (weak, nonatomic) IBOutlet UILabel *onLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label ceny lpg
 */
@property (weak, nonatomic) IBOutlet UILabel *lpgLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label komentarza
 */
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe z nazwą stacji
 */
@property (weak, nonatomic) IBOutlet UITextField *stationNameTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tesktowe z adresem stacji
 */
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe ceny pb95
 */
@property (weak, nonatomic) IBOutlet UITextField *pb95TextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe ceny pb98
 */
@property (weak, nonatomic) IBOutlet UITextField *pb98TextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tesktowe ceny on
 */
@property (weak, nonatomic) IBOutlet UITextField *onTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe ceny lpg
 */
@property (weak, nonatomic) IBOutlet UITextField *lpgTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tesktowe komentarza
 */
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

/*!
 * @author Damian Klimaszewski
 * @discussion Scroll widok
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk dodania stacji
 */
@property (weak, nonatomic) IBOutlet UIButton *addStationButton;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk anulowania dodawania stacji
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Dodanie stacji do bazy
 */
- (IBAction)addStationAction:(id)sender;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Anulowanie dodawania stacji
 */
- (IBAction)cancelAction:(id)sender;

/*!
 * @author Damian Klimaszewski
 * @discussion Switch aktualnej pozycji
 */
@property (weak, nonatomic) IBOutlet UISwitch *actualPositionSwitch;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok, z którego został uruchomiony AddStationViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@end
