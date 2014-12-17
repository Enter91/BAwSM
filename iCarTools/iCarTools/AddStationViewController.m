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

}

- (IBAction)cancelAction:(id)sender {

}

@end
