//
//  SettingsViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellsTitles = [[NSArray alloc] init];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"login info view: %@", NSStringFromCGRect(_loginInfoView.frame));
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 30.0)];
    [logoutButton setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton.titleLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:15]];
    [logoutButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [_loginInfoView addSubview:logoutButton];
    [logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [logoutButton addConstraint:[NSLayoutConstraint constraintWithItem:logoutButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
    [logoutButton addConstraint:[NSLayoutConstraint constraintWithItem:logoutButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [_loginInfoView addConstraint:[NSLayoutConstraint constraintWithItem:logoutButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_loginInfoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0]];
    [_loginInfoView addConstraint:[NSLayoutConstraint constraintWithItem:logoutButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_loginInfoView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.revealViewController.rearViewRevealWidth-100-5]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate clickedOption:(int)indexPath.row];
    
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
