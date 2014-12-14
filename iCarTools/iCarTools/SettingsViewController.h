//
//  SettingsViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>

@protocol SettingsViewControllerDelegate <NSObject>

- (void)clickedOption:(int)number;

@end

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithCellsTitlesArray:(NSArray *)titlesArray;

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (strong, nonatomic) NSArray *cellsTitles;
@property (weak, nonatomic) IBOutlet UIView *loginInfoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property int menuType;

- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray;
- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray andMenuType:(int)depth;

@property (nonatomic, assign) id delegate;
@end
