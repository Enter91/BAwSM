//
//  SettingsViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellsTitles = [[NSArray alloc] init];
        _menuType = 0;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cellsTitles = [[NSArray alloc] init];
        _menuType = 0;
        [_settingsTableView reloadData];
    }
    
    return self;
}

- (id)initWithCellsTitlesArray:(NSArray *)titlesArray {
    
    self = [super init];
    if (self) {
        _cellsTitles = [[NSArray alloc] initWithArray:titlesArray];
        
        [_settingsTableView reloadData];
    }
    
    return self;
}

- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray {
    _cellsTitles = nil;
    _cellsTitles = [[NSArray alloc] initWithArray:titlesArray];
    
    [_settingsTableView reloadData];
}

- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray andMenuType:(int)depth {
    _cellsTitles = nil;
    _cellsTitles = [[NSArray alloc] initWithArray:titlesArray];
    
    _menuType = depth;
    
    [_settingsTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogged"] == [NSNumber numberWithBool:YES]) {
        [_usernameLabel setText:[NSString stringWithFormat:@"%@ %@", [[UserInfo sharedInstance] first_name], [[UserInfo sharedInstance] last_name]]];
    } else {
        [_usernameLabel setText:NSLocalizedString(@"Click here to login", nil)];
    }
    
    if (_tmpAvatarImage) {
        _avatarImageView.image = nil;
        _avatarImageView.image = _tmpAvatarImage;
        _tmpAvatarImage = nil;
        [_avatarImageView.layer setCornerRadius:25.0];
    } else {
        _avatarImageView.image = nil;
        _avatarImageView.image = [UIImage imageNamed:@"user_male4-256"];
        [_avatarImageView.layer setCornerRadius:0.0];
    }
    
    NSLog(@"login info view: %@", NSStringFromCGRect(_loginInfoView.frame));
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(90.0, 20.0, 170.0, 60.0)];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_loginInfoView addSubview:_loginButton];
    
    _logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 30.0)];
    [_logoutButton setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutButton.titleLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:15]];
    [_logoutButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self showLogInOutButtons];
    
    [_loginInfoView addSubview:_logoutButton];
    [_logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_logoutButton addConstraint:[NSLayoutConstraint constraintWithItem:_logoutButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
    [_logoutButton addConstraint:[NSLayoutConstraint constraintWithItem:_logoutButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [_loginInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_logoutButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_loginInfoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0]];
    [_loginInfoView addConstraint:[NSLayoutConstraint constraintWithItem:_logoutButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_loginInfoView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.revealViewController.rearViewRevealWidth-100-5]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUserInfoWithName:(NSString *)labelText andAvatar:(UIImage *)avatar {
    
    if (labelText.length > 0 && [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogged"] == [NSNumber numberWithBool:YES]) {
        if (_usernameLabel != nil) {
            [_usernameLabel setText:labelText];
        }
    } else {
        if (_usernameLabel != nil) {
            [_usernameLabel setText:NSLocalizedString(@"Click here to login", nil)];
            _tmpUsernameLabelString = nil;
        }
    }
    
    if (avatar != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogged"] == [NSNumber numberWithBool:YES]) {
        if (_avatarImageView) {
            _avatarImageView.image = nil;
            _avatarImageView.image = avatar;
            [_avatarImageView.layer setCornerRadius:25.0];
            _tmpAvatarImage = nil;
            _tmpAvatarImage = avatar;
        } else {
            _tmpAvatarImage = nil;
            _tmpAvatarImage = avatar;
        }
        
    } else {
        if (_avatarImageView) {
            _avatarImageView.image = nil;
            _avatarImageView.image = [UIImage imageNamed:@"user_male4-256"];
            [_avatarImageView.layer setCornerRadius:0.0];
            _tmpAvatarImage = nil;
        } else {
            _tmpAvatarImage = nil;
            _tmpAvatarImage = [UIImage imageNamed:@"user_male4-256"];
        }
    }
    
}

- (void)loginAction {
    
    [self showLogInOutButtons];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
    
    [appDelegate showLoginViewScreen];
}

- (void)logoutAction {
    LoginManager *loginMan = [[LoginManager alloc] init];
    [loginMan logoutUser];
    
    [self setUserInfoWithName:@"" andAvatar:nil];
    
    [self showLogInOutButtons];
}

- (void)showLogInOutButtons {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogged"] == [NSNumber numberWithBool:NO]) {
        [_loginButton setAlpha:1.0];
        [_logoutButton setAlpha:0.0];
        
        [_loginButton setUserInteractionEnabled:YES];
        [_logoutButton setUserInteractionEnabled:NO];
    } else {
        [_loginButton setAlpha:0.0];
        [_logoutButton setAlpha:1.0];
        
        [_loginButton setUserInteractionEnabled:NO];
        [_logoutButton setUserInteractionEnabled:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_cellsTitles objectAtIndex:row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cellsTitles count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_delegate clickedOption:(int)indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark- UINavigationController Delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
