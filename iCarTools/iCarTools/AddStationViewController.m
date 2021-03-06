//
//  AddStationViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 17.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "AddStationViewController.h"

@interface AddStationViewController ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) GPSUtilities *gpsUtilities;

@end

@implementation AddStationViewController{
    CLLocation *userLocation;
    BOOL numericError;
    BOOL nameError;
    id gas_station_id;
    int gas_station_id_int;
    UIGestureRecognizer *tapper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    [self.gpsUtilities startGPS];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    
    [_stationNameLabel setText:NSLocalizedString(@"StationName", nil)];
    [_addresLabel setText:NSLocalizedString(@"Address", nil)];
    [_actualPositionLabel setText:NSLocalizedString(@"ActualPosition", nil)];
    [_pricesLabel setText:NSLocalizedString(@"Prices", nil)];
    [_pb95Label setText:NSLocalizedString(@"Pb95", nil)];
    [_pb98Label setText:NSLocalizedString(@"Pb98", nil)];
    [_onLabel setText:NSLocalizedString(@"On", nil)];
    [_lpgLabel setText:NSLocalizedString(@"Lpg", nil)];
    [_commentLabel setText:NSLocalizedString(@"Comment", nil)];
    
    [_addStationButton setTitle:NSLocalizedString(@"AddStation", nil) forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    
    [_stationNameLabel setFrame:CGRectMake(8, 40, 105, 30)];
    [_addresLabel setFrame:CGRectMake(8, 85, 105, 30)];
    [_actualPositionLabel setFrame:CGRectMake(185, 126, 100, 30)];
    [_pricesLabel setFrame:CGRectMake(108, 185, 105, 30)];
    [_pb95Label setFrame:CGRectMake(8, 225, 80, 30)];
    [_pb98Label setFrame:CGRectMake(8, 280, 80, 30)];
    [_onLabel setFrame:CGRectMake(140, 225, 80, 30)];
    [_lpgLabel setFrame:CGRectMake(140, 280, 80, 30)];
    [_commentLabel setFrame:CGRectMake(108, 340, 105, 30)];
    [_addStationButton setFrame:CGRectMake(35, 490, 120, 40)];
    [_cancelButton setFrame:CGRectMake(190, 490, 90, 40)];
    [_commentTextView setFrame:CGRectMake(10, 380, 300, 60)];
    [_actualPositionSwitch setFrame:CGRectMake(130, 125, 51, 31)];
    [_stationNameTextField setFrame:CGRectMake(130, 40, 150, 30)];
    [_addressTextField setFrame:CGRectMake(130, 85, 150, 30)];
    [_pb95TextField setFrame:CGRectMake(75, 225, 80, 30)];
    [_pb98TextField setFrame:CGRectMake(75, 280, 80, 30)];
    [_onTextField setFrame:CGRectMake(207, 225, 80, 30)];
    [_lpgTextField setFrame:CGRectMake(207, 280, 80, 30)];
    
    [self.cancelButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.actualPositionSwitch removeTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actualPositionSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBar.hidden = YES;
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    nameError = NO;
    numericError = NO;
    [self setFramesForInterface:self.interfaceOrientation];
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.navigationController.navigationBar endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lockStationsButtons {
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(unlockStationsButtons) object:nil];
    [self performSelector:@selector(unlockStationsButtons) withObject:nil afterDelay:5.0];
    [_addStationButton setUserInteractionEnabled:NO];
    [_cancelButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [_addStationButton setAlpha:0.5];
        [_cancelButton setAlpha:0.5];
    }];
}

- (void)unlockStationsButtons {
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(unlockStationsButtons) object:nil];
    [_addStationButton setUserInteractionEnabled:YES];
    [_cancelButton setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [_addStationButton setAlpha:1.0];
        [_cancelButton setAlpha:1.0];
    }];
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    NSLog(@"response: %@", responseDict);
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        nameError = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        [self unlockStationsButtons];
    }
    
    if ([[responseDict objectForKey:@"code"] intValue] == 202) {
        
        numericError = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        [self unlockStationsButtons];
    }

    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        
        numericError = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        [self unlockStationsButtons];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addStationAlert"];
    }
    
    if ([[responseDict objectForKey:@"code"] intValue] == 401) {
        
        nameError = NO;
        
        gas_station_id = [responseDict objectForKey:@"gas_station_id"];
        gas_station_id_int = [gas_station_id intValue];
        
        if ([_pb95TextField.text isEqual:@""] && [_pb98TextField.text isEqual:@""] && [_onTextField.text isEqual:@""] && [_lpgTextField.text isEqual:@""] && [_commentTextView.text isEqual:@""]) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
    }
    
    if ([[responseDict objectForKey:@"code"] intValue] == 402) {
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

- (void)sendAddress:(NSString*)address {
    _addressTextField.text = address;
}

- (void)addStationDatabaseConnect:(CLLocationCoordinate2D )coordinate {
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/addStation.php?name=%@&address=%@&latitude=%f&longitude=%f", _stationNameTextField.text, _addressTextField.text,coordinate.latitude,coordinate.longitude]];
}

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

- (void)removeStation {

    [[AmazingJSON sharedInstance] setDelegate:self];
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/removeStation.php?name=%@", _stationNameTextField.text]];
}

/*!
 *  @Author Damian Klimaszewski
 *
 *  Add station into database
 */
- (IBAction)addStationAction:(id)sender {
 
    if(![_stationNameTextField.text isEqual:@""]) {
        
     if(![_addressTextField.text isEqual:@""] || _actualPositionSwitch.on) {
         
         if (![_pb95TextField.text isEqual:@""] || ![_pb98TextField.text isEqual:@""] || ![_onTextField.text isEqual:@""] || ![_lpgTextField.text isEqual:@""] || ![_commentTextView.text isEqual:@""]) {
         
             [self lockStationsButtons];
             if (_actualPositionSwitch.on) {
            
                 if (!self.geocoder)
                     self.geocoder = [[CLGeocoder alloc] init];
        
                [self.geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error){
                CLPlacemark *placemark = placemarks[0];
            
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = userLocation.coordinate.latitude;
                coordinate.longitude = userLocation.coordinate.longitude;
                     
                [self sendAddress:placemark.name];
                [self addStationDatabaseConnect:coordinate];
                }];
             }
             else {
            
                 if (!self.geocoder)
                     self.geocoder = [[CLGeocoder alloc] init];
        
                [self.geocoder geocodeAddressString:_addressTextField.text
                          completionHandler:^(NSArray* placemarks, NSError* error){
                              
                              if (error == nil) {
                                  CLLocationCoordinate2D coordinate;
                                  CLPlacemark *placemark = [placemarks lastObject];
                                  CLLocation *location = placemark.location;
                                  coordinate = location.coordinate;
                                  
                                  [self addStationDatabaseConnect:coordinate];
                              }
                              else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Address unknown error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                                  alert = nil;

                              }
                          }];

             }
             
             double delayInSeconds = 2.0;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 
                 if(nameError == NO) {
                     [self addVisitDatabaseConnect];
                 
                     double delayInSeconds = 2.0;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                     
                         if (numericError == YES) {
                             [self removeStation];
                         } else {
                             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showAnnotations"];
                         }
                     });
                 }
             });
         
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please, write some visit info"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             alert = nil;

         }
     } else {
         
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Address is empty"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
          }
     } else {
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Station name is empty"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        [_stationNameLabel setFrame:CGRectMake(8, 40, 105, 30)];
        [_addresLabel setFrame:CGRectMake(8, 85, 105, 30)];
        [_actualPositionLabel setFrame:CGRectMake(185, 126, 100, 30)];
        [_pricesLabel setFrame:CGRectMake(108, 185, 105, 30)];
        [_pb95Label setFrame:CGRectMake(8, 225, 80, 30)];
        [_pb98Label setFrame:CGRectMake(8, 280, 80, 30)];
        [_onLabel setFrame:CGRectMake(140, 225, 80, 30)];
        [_lpgLabel setFrame:CGRectMake(140, 280, 80, 30)];
        [_commentLabel setFrame:CGRectMake(108, 340, 105, 30)];
        [_addStationButton setFrame:CGRectMake(35, 490, 120, 40)];
        [_cancelButton setFrame:CGRectMake(190, 490, 90, 40)];
        [_commentTextView setFrame:CGRectMake(10, 380, 300, 60)];
        [_actualPositionSwitch setFrame:CGRectMake(130, 125, 51, 31)];
        [_stationNameTextField setFrame:CGRectMake(130, 40, 150, 30)];
        [_addressTextField setFrame:CGRectMake(130, 85, 150, 30)];
        [_pb95TextField setFrame:CGRectMake(75, 225, 80, 30)];
        [_pb98TextField setFrame:CGRectMake(75, 280, 80, 30)];
        [_onTextField setFrame:CGRectMake(207, 225, 80, 30)];
        [_lpgTextField setFrame:CGRectMake(207, 280, 80, 30)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_stationNameLabel setFrame:CGRectMake(8, 20, 105, 30)];
        [_addresLabel setFrame:CGRectMake(8, 65, 105, 30)];
        [_actualPositionLabel setFrame:CGRectMake(185, 106, 100, 30)];
        [_pricesLabel setFrame:CGRectMake(108, 165, 105, 30)];
        [_pb95Label setFrame:CGRectMake(8, 205, 80, 30)];
        [_pb98Label setFrame:CGRectMake(8, 260, 80, 30)];
        [_onLabel setFrame:CGRectMake(140, 205, 80, 30)];
        [_lpgLabel setFrame:CGRectMake(140, 260, 80, 30)];
        [_commentLabel setFrame:CGRectMake(368, 20, 105, 30)];
        [_addStationButton setFrame:CGRectMake(305, 145, 120, 40)];
        [_cancelButton setFrame:CGRectMake(455, 145, 90, 40)];
        [_commentTextView setFrame:CGRectMake(328, 60, 190, 70)];
        [_actualPositionSwitch setFrame:CGRectMake(130, 105, 51, 31)];
        [_stationNameTextField setFrame:CGRectMake(130, 20, 150, 30)];
        [_addressTextField setFrame:CGRectMake(130, 65, 150, 30)];
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

- (void)mapType {
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

- (void)switchAction {
    if (_actualPositionSwitch.on) {
        [_addressTextField setUserInteractionEnabled:NO];
        _addressTextField.text = @"";
        [_addressTextField setBackgroundColor: [UIColor grayColor]];
    }
    else {
        [_addressTextField setUserInteractionEnabled:YES];
        [_addressTextField setBackgroundColor: [UIColor whiteColor]];
    }
}

- (void)exit {

    [self.revealViewController setFrontViewController:_parentView animated:YES];
    self.gpsUtilities.delegate = _parentView;
    _parentView = nil;
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = YES;
}
@end
