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
#import "AddStationViewController.h"
#import "ChangeViewController.h"
#import "PricesViewController.h"
#import "SearchViewController.h"
#import "FixedCompassLayout.h"

@import AVFoundation;
@import AssetsLibrary;
@import MobileCoreServices;

/*!
 * @author Damian Klimaszewski
 * @discussion Główna klasa mapy cen paliw
 */
@interface StatsViewController : UIViewController <GPSUtilitiesDelegate, MKMapViewDelegate, AmazingJSONDelegate, SettingsViewControllerDelegate>

/*!
 * @author Damian Klimaszewski
 * @discussion Główny widok
 */
@property (strong, nonatomic) IBOutlet UIView *view;

/*!
 * @author Damian Klimaszewski
 * @discussion Widok mapy
 */
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Przycisk przenosi użytkownika do widoku dodania stacji
 */
- (IBAction)addStationAction:(id)sender;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Przycisk wyszukiwania stacji na mapie
 */
- (IBAction)findStationAction:(id)sender;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok dodawania stacji
 */
@property (strong, nonatomic) AddStationViewController *addStationView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok modyfikacji wizyt w bazie
 */
@property (strong, nonatomic) ChangeViewController *changeStationView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok cen paliw z bazy
 */
@property (strong, nonatomic) PricesViewController *pricesView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok wyszukiwania stacji
 */
@property (strong, nonatomic) SearchViewController *searchView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok, z którego został uruchomiony StatsViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Flaga określająca, czy kontroler żąda customowej animacji uruchamianej z SWRevealController
 */
@property (nonatomic) BOOL wantsCustomAnimation;

@end
