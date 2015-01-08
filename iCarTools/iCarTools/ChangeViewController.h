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

/*!
 * @author Damian Klimaszewski
 * @discussion Klasa modyfikacji cen w bazie
 */
@interface ChangeViewController : UIViewController <UITextFieldDelegate, AmazingJSONDelegate, GPSUtilitiesDelegate, AmazingJSONDelegate, UIAlertViewDelegate>

/*!
 * @author Damian Klimaszewski
 * @discussion Label nazwa stacji
 */
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label adresu stacji
 */
@property (weak, nonatomic) IBOutlet UILabel *addresLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Label cen
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
 * @discussion Pole tesktowe nazwy stacji
 */
@property (weak, nonatomic) IBOutlet UITextField *stationNameTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe adresu stacji
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
 * @discussion Pole tekstowe ceny on
 */
@property (weak, nonatomic) IBOutlet UITextField *onTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Label Pole tekstowe ceny lpg
 */
@property (weak, nonatomic) IBOutlet UITextField *lpgTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe komentarza
 */
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk zapisu do bazy
 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk anulowania zapisu
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Zapis wizyty na stacji do bazy
 *  @param  sender Obiekt wywołujący akcję
 */
- (IBAction)saveAction:(id)sender;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Anulowanie dodania wizyty
 *  @param  sender Obiekt wywołujący akcję
 */
- (IBAction)cancelAction:(id)sender;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok, z którego został uruchomiony ChangeViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@end
