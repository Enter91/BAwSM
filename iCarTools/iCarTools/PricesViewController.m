//
//  PricesViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 30.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "PricesViewController.h"

@interface PricesViewController ()

@end

@implementation PricesViewController {
    NSArray *responseArray;
    NSMutableArray *visits;
    NSString *shareText;
    UIButton *button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wantsCustomAnimation = YES;
    
    [_backButton setFrame:CGRectMake(115, 528, 90, 40)];
    [_tableView setFrame:CGRectMake(0, 0, 320, 530)];
    
    [self.backButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.delegate = self;
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/getList.php?name=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"stationName"]]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundView = imageView;
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setFramesForInterface:self.interfaceOrientation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [visits count];
}

/**
 *  @Author Damian Klimaszewski
 *
 *  Table view with visits
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:14.0];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"DINPro-Medium" size:14.0];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [visits objectAtIndex:indexPath.row];
    shareText = cell.textLabel.text;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"upload-50"];
    [button setImage:btnImage forState:UIControlStateNormal];
    button.frame = CGRectMake(cell.frame.origin.x + 250, cell.frame.origin.y + 5, 35, 35);
    [button addTarget:self action:@selector(shareForSelector) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor= [UIColor clearColor];
    [cell.contentView addSubview:button];
    return cell;
}

- (void)shareForSelector {
    [self shareText:shareText andImage:nil andUrl:nil];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityController animated:YES completion:nil];
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
    
    if ([[responseDict objectForKey:@"code"] intValue] == 405) {
        
        if (responseArray) {
            responseArray = nil;
        }
        responseArray = [responseDict objectForKey:@"response"];
        visits=[[NSMutableArray alloc] init];
        
        for (int i = 0; i<[responseArray count]; i++) {
            
            NSString *categoryString = nil;
            categoryString = responseArray[i][@"name"];
            NSString *first_name = responseArray[i][@"first_name"];
            NSString *last_name = responseArray[i][@"last_name"];
            NSString *pb95 = responseArray[i][@"pb95_price"];
            if ([pb95 isEqual:@"0"]) {
                pb95 = @"-";
            }
            if ([pb95 length]>4) {
                pb95 = [pb95 substringToIndex: 4];
            }
            NSString *pb98 = responseArray[i][@"pb98_price"];
            if ([pb98 isEqual:@"0"]) {
                pb98 = @"-";
            }
            if ([pb98 length]>4) {
                pb98 = [pb98 substringToIndex: 4];
            }
            NSString *on = responseArray[i][@"on_price"];
            if ([on isEqual:@"0"]) {
                on = @"-";
            }
            if ([on length]>4) {
                on = [on substringToIndex: 4];
            }
            NSString *lpg = responseArray[i][@"lpg_price"];
            if ([lpg isEqual:@"0"]) {
                lpg = @"-";
            }
            if ([lpg length]>4) {
                lpg = [lpg substringToIndex: 4];
            }
            NSString *comment = responseArray[i][@"comment"];
            if ([comment isEqual:@""]) {
                comment = @"-";
            }
            NSString *visitdate = responseArray[i][@"visit_date"];
            NSString *subtitle;
            subtitle = [NSString stringWithFormat:@"%@\r%@ %@ \r\rPb95: %@   Pb98: %@   On: %@   Lpg: %@ \r\rComment: %@",visitdate,first_name,last_name,pb95,pb98,on,lpg,comment];
            
            if (i == 0) {
                NSString *lastPrice;
                lastPrice = [NSString stringWithFormat:@"Last Price\r\rPb95: %@   Pb98: %@   On: %@   Lpg: %@",pb95,pb98,on,lpg];
                [visits addObject:lastPrice];
            }
            
            [visits addObject:subtitle];
        }
        [self.tableView reloadData];
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
        [_tableView setFrame:CGRectMake(0, 0, 320, 530)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_backButton setFrame:CGRectMake(240, 280, 90, 40)];
        [_tableView setFrame:CGRectMake(0, 0, 568, 280)];
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

- (IBAction)backButtonAction:(id)sender {
}

@end
