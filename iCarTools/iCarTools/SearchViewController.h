//
//  SearchViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>
#import <MapKit/MapKit.h>
#import "AmazingJSON.h"

@import AVFoundation;
@import AssetsLibrary;
@import MobileCoreServices;

/*!
 * @author Damian Klimaszewski
 * @discussion Klasa wyszukiwania stacji
 */
@interface SearchViewController : UIViewController <MKMapViewDelegate, AmazingJSONDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

/*!
 *  @author Damian Klimaszewski
 *  @discussion Widok, z którego został uruchomiony SearchViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

/*!
 * @author Damian Klimaszewski
 * @discussion Widok tabeli
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 * @author Damian Klimaszewski
 * @discussion Tabela stacji
 */
@property (nonatomic, strong) NSMutableArray *tableData;

/*!
 * @author Damian Klimaszewski
 * @discussion Pasek wyszukiwania
 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOutlet;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk powrotu
 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
