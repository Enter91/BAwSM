//
//  AddStationViewController.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 17.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "AddStationViewController.h"

@interface AddStationViewController ()

@end

@implementation AddStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wantsCustomAnimation = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
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
    
    
    [self.cancelButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self updateDataSourceInLeftRevealViewController];
    
    [self setFramesForInterface:self.interfaceOrientation];
   
}

- (void)updateDataSourceInLeftRevealViewController {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[
                                                                                                              NSLocalizedString(@"normal", nil),
                                                                                                              NSLocalizedString(@"hybrid", nil),
                                                                                                              NSLocalizedString(@"satellite", nil)]
                                                                                                andMenuType:0];
    }
}

- (void)sendCoordinate:(CLLocationCoordinate2D )coordinate {
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/addStation.php?name=%@&address=%@&latitude=%f&longitude=%f", @"Stacja", @"Niedziałkowskiego 1 Szczecin",coordinate.latitude,coordinate.longitude]];
    
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
}

- (IBAction)addStationAction:(id)sender {
   
    if (!self.geocoder)
        self.geocoder = [[CLGeocoder alloc] init];
    
    [self.geocoder geocodeAddressString:@"Niedziałkowskiego 1 Szczecin"
                      completionHandler:^(NSArray* placemarks, NSError* error){
                          if (error == nil) {
                              CLLocationCoordinate2D coordinate;
                              // Process the placemark.
                              CLPlacemark *placemark = [placemarks lastObject];
                              CLLocation *location = placemark.location;
                              coordinate = location.coordinate;
                              
                              [self sendCoordinate:coordinate];
                          }
                          else {
                          }
                      }];

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

    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
       
    });
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)mapType {
}

- (void)locationUpdate:(CLLocation *)location {
    NSLog(@"New Location: %@", location);
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
    _parentView = nil;
}

@end
