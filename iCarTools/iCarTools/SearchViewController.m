//
//  SearchViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController {
    NSArray *responseArray;
    NSMutableArray *stations;
    CLLocationCoordinate2D stationCoordinate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wantsCustomAnimation = YES;
    
    [_backButton setFrame:CGRectMake(115, 528, 90, 40)];
    [_tableView setFrame:CGRectMake(0, 44, 320, 486)];
    
    [self.backButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.delegate = self;
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/getStationList.php?latitude=%@&longitude=%@&diff=%f",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userLong"],0.5]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundView = imageView;
    //self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setFramesForInterface:self.interfaceOrientation];
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[stations objectAtIndex:indexPath.row] forKey:@"selectedRow"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.tableData[indexPath.row] forKey:@"selectedRow"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"zoom"];
   [self exit];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [stations removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    stations = [NSMutableArray arrayWithArray: [self.tableData filteredArrayUsingPredicate:resultPredicate]];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [stations count];
    }
    else
    {
        return [self.tableData count];
    }}

/**
 *  @Author Damian Klimaszewski
 *
 *  Table view with stations
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    //tableView.allowsSelection = NO;
    cell.textLabel.font = [UIFont fontWithName:@"DINPro-Medium" size:14.0];
    cell.textLabel.numberOfLines = 0; //no max
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [stations objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = self.tableData[indexPath.row];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    NSLog(@"response: %@", responseDict);
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    
    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        if (responseArray) {
            responseArray = nil;
        }
        responseArray = [responseDict objectForKey:@"response"];
        self.tableData = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<[responseArray count]; i++) {
            
            NSString *categoryString = nil;
            categoryString = responseArray[i][@"name"];
            stationCoordinate.latitude = [responseArray[i][@"latitude"] doubleValue];
            stationCoordinate.longitude = [responseArray[i][@"longitude"] doubleValue];
            //NSString *subtitle = responseArray[i][@"address"];
            
            NSString *station;
            station = [NSString stringWithFormat:@"%@",categoryString];
            [self.tableData addObject:station];
        }
        stations = [NSMutableArray arrayWithCapacity:[self.tableData count]];
        [self.tableView reloadData];

        //responseArray = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex  == [alertView cancelButtonIndex]){
        [self exit];
    }else{
        //reset clicked
    }
}

- (void)setFramesForInterface:(UIInterfaceOrientation)toInterfaceOrientation {
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationPortrait:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self setFramesForLandscapeLeft];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self setFramesForLandscapeLeft];
            break;
        default:
            break;
    }
}

- (void)setFramesForPortrait {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_backButton setFrame:CGRectMake(115, 528, 90, 40)];
        [_tableView setFrame:CGRectMake(0, 44, 320, 486)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_backButton setFrame:CGRectMake(240, 280, 90, 40)];
        [_tableView setFrame:CGRectMake(0, 44, 568, 236)];
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)exit {
    
    [self.revealViewController setFrontViewController:_parentView animated:YES];
    _parentView = nil;
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = YES;
}

@end
