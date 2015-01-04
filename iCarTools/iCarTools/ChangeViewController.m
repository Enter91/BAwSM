//
//  ChangeStationViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 17.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "ChangeViewController.h"

@interface ChangeViewController ()

@end

@implementation ChangeViewController{
    CLLocation *userLocation;
    BOOL numericError;
    id gas_station_id;
    int gas_station_id_int;
    NSArray *responseArray;
    UIGestureRecognizer *tapper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    [self.gpsUtilities startGPS];
    
    _wantsCustomAnimation = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    
    [_stationNameLabel setText:NSLocalizedString(@"StationName", nil)];
    [_addresLabel setText:NSLocalizedString(@"Address", nil)];
    [_pricesLabel setText:NSLocalizedString(@"Prices", nil)];
    [_pb95Label setText:NSLocalizedString(@"Pb95", nil)];
    [_pb98Label setText:NSLocalizedString(@"Pb98", nil)];
    [_onLabel setText:NSLocalizedString(@"On", nil)];
    [_lpgLabel setText:NSLocalizedString(@"Lpg", nil)];
    [_commentLabel setText:NSLocalizedString(@"Comment", nil)];
    
    [_saveButton setTitle:NSLocalizedString(@"AddVisit", nil) forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    
    [_stationNameLabel setFrame:CGRectMake(108, 8, 105, 30)];
    [_addresLabel setFrame:CGRectMake(108, 84, 105, 30)];
    [_pricesLabel setFrame:CGRectMake(108, 171, 105, 30)];
    [_pb95Label setFrame:CGRectMake(8, 225, 80, 30)];
    [_pb98Label setFrame:CGRectMake(8, 280, 80, 30)];
    [_onLabel setFrame:CGRectMake(140, 225, 80, 30)];
    [_lpgLabel setFrame:CGRectMake(140, 280, 80, 30)];
    [_commentLabel setFrame:CGRectMake(108, 340, 105, 30)];
    
    [_saveButton setFrame:CGRectMake(35, 490, 122, 40)];
    [_cancelButton setFrame:CGRectMake(190, 490, 90, 40)];
    
    [_commentTextView setFrame:CGRectMake(10, 380, 300, 60)];
    
    [_stationNameTextField setFrame:CGRectMake(35, 46, 250, 30)];
    [_addressTextField setFrame:CGRectMake(35, 122, 250, 30)];
    [_pb95TextField setFrame:CGRectMake(75, 225, 80, 30)];
    [_pb98TextField setFrame:CGRectMake(75, 280, 80, 30)];
    [_onTextField setFrame:CGRectMake(207, 225, 80, 30)];
    [_lpgTextField setFrame:CGRectMake(207, 280, 80, 30)];
    
    [self.cancelButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    _stationNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"stationName"];
    _addressTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"stationAddress"];
    
    self.navigationController.navigationBar.hidden = YES;
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    [self setFramesForInterface:self.interfaceOrientation];
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.navigationController.navigationBar endEditing:YES];
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
    
    if ([[responseDict objectForKey:@"code"] intValue] == 202) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }

    
    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    
    if ([[responseDict objectForKey:@"code"] intValue] == 403) {
        
        if (responseArray) {
            responseArray = nil;
        }
        responseArray = [responseDict objectForKey:@"response"];
        gas_station_id_int = [responseArray[0][@"gas_station_id"] intValue];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [self exit];
    }else{
        //reset clicked
    }
}

- (void) getStationIdDatabaseConnect {
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/getStationId.php?name=%@", _stationNameTextField.text]];
}

/**
 *  @Author Damian Klimaszewski
 *
 *  Save visit in database
 */
- (void) addVisitDatabaseConnect {
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    _pb95TextField.text = [_pb95TextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    _pb98TextField.text = [_pb98TextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    _onTextField.text = [_onTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    _lpgTextField.text = [_lpgTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];

    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/addVisit.php?user_id=%d&gas_station_id=%d&visit_date=%@&pb95_price=%@&pb98_price=%@&on_price=%@&lpg_price=%@&comment=%@", [[UserInfo sharedInstance] user_id], gas_station_id_int, date_String, _pb95TextField.text, _pb98TextField.text, _onTextField.text, _lpgTextField.text, _commentTextView.text]];
    
    dateformate = nil;
    date_String = nil;
}

- (IBAction)saveAction:(id)sender {
    
         if (![_pb95TextField.text isEqual:@""] || ![_pb98TextField.text isEqual:@""] || ![_onTextField.text isEqual:@""] || ![_lpgTextField.text isEqual:@""] || ![_commentTextView.text isEqual:@""]) {
             
             [self getStationIdDatabaseConnect];
             
             double delayInSeconds = 1.0;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 
                 [self addVisitDatabaseConnect];
             });
         
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please, write some visit info"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             alert = nil;

         }
}

- (IBAction)cancelAction:(id)sender {
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
        [_stationNameLabel setFrame:CGRectMake(108, 8, 105, 30)];
        [_addresLabel setFrame:CGRectMake(108, 84, 105, 30)];
        [_pricesLabel setFrame:CGRectMake(108, 171, 105, 30)];
        [_pb95Label setFrame:CGRectMake(8, 225, 80, 30)];
        [_pb98Label setFrame:CGRectMake(8, 280, 80, 30)];
        [_onLabel setFrame:CGRectMake(140, 225, 80, 30)];
        [_lpgLabel setFrame:CGRectMake(140, 280, 80, 30)];
        [_commentLabel setFrame:CGRectMake(108, 340, 105, 30)];
        
        [_saveButton setFrame:CGRectMake(35, 490, 122, 40)];
        [_cancelButton setFrame:CGRectMake(190, 490, 90, 40)];
        
        [_commentTextView setFrame:CGRectMake(10, 380, 300, 60)];
        
        [_stationNameTextField setFrame:CGRectMake(35, 46, 250, 30)];
        [_addressTextField setFrame:CGRectMake(35, 122, 250, 30)];
        [_pb95TextField setFrame:CGRectMake(75, 225, 80, 30)];
        [_pb98TextField setFrame:CGRectMake(75, 280, 80, 30)];
        [_onTextField setFrame:CGRectMake(207, 225, 80, 30)];
        [_lpgTextField setFrame:CGRectMake(207, 280, 80, 30)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_stationNameLabel setFrame:CGRectMake(108, 8, 105, 30)];
        [_addresLabel setFrame:CGRectMake(108, 84, 105, 30)];
        [_pricesLabel setFrame:CGRectMake(108, 165, 105, 30)];
        [_pb95Label setFrame:CGRectMake(8, 205, 80, 30)];
        [_pb98Label setFrame:CGRectMake(8, 260, 80, 30)];
        [_onLabel setFrame:CGRectMake(140, 205, 80, 30)];
        [_lpgLabel setFrame:CGRectMake(140, 260, 80, 30)];
        [_commentLabel setFrame:CGRectMake(368, 20, 105, 30)];
        
        [_saveButton setFrame:CGRectMake(305, 145, 122, 40)];
        [_cancelButton setFrame:CGRectMake(455, 145, 90, 40)];
        
        [_commentTextView setFrame:CGRectMake(328, 60, 190, 70)];
        
        [_stationNameTextField setFrame:CGRectMake(35, 44, 250, 30)];
        [_addressTextField setFrame:CGRectMake(35, 122, 250, 30)];
        [_pb95TextField setFrame:CGRectMake(75, 205, 80, 30)];
        [_pb98TextField setFrame:CGRectMake(75, 260, 80, 30)];
        [_onTextField setFrame:CGRectMake(207, 205, 80, 30)];
        [_lpgTextField setFrame:CGRectMake(207, 260, 80, 30)];
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)gpsDidChangeState:(int)state {
}

- (void)locationUpdate:(CLLocation *)location {
    NSLog(@"New Location: %@", location);
    userLocation = location;
}

- (void)locationError:(NSError *)error {
    NSLog(@"Location error: %@", [error localizedDescription]);
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
    self.gpsUtilities.delegate = _parentView;
    _parentView = nil;
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = YES;
}
@end
