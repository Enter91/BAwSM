//
//  SettingsViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithCellsTitlesArray:(NSArray *)titlesArray;

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (strong, nonatomic) NSArray *cellsTitles;
@property (weak, nonatomic) IBOutlet UIView *loginInfoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
