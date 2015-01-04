//
//  SettingsViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>
#import "LoginManager.h"
#import "LoginViewController.h"

@protocol SettingsViewControllerDelegate <NSObject>

- (void)clickedOption:(int)number inMenuType:(int)menuType;

@end

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithCellsTitlesArray:(NSArray *)titlesArray;

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (strong, nonatomic) NSArray *cellsTitles;
@property (strong, nonatomic) NSString *tmpUsernameLabelString;
@property (strong, nonatomic) UIImage *tmpAvatarImage;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UIView *loginInfoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property int menuType;
@property int activeOption;

- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray;
- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray andMenuType:(int)depth;
- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray indexOfActiveOption:(int)activeIndex andMenuType:(int)depth;

@property (nonatomic, assign) id delegate;

- (void)setUserInfoWithName:(NSString *)labelText andAvatar:(UIImage *)avatar;

@end
