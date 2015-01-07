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

@interface SearchViewController : UIViewController <MKMapViewDelegate, AmazingJSONDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

/**
 *  @author Damian Klimaszewski
 *
 *  Widok, z którego został uruchomiony SearchViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  Tablica stacji
 */
@property (nonatomic, strong) NSMutableArray *tableData;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOutlet;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
