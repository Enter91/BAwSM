//
//  AddStationViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 17.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmazingJSON.h"

@interface AddStationViewController : UIViewController <UITextFieldDelegate, AmazingJSONDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *pb95Label;
@property (weak, nonatomic) IBOutlet UILabel *pb98Label;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;
@property (weak, nonatomic) IBOutlet UILabel *lpgLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UITextField *stationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *pb95TextField;
@property (weak, nonatomic) IBOutlet UITextField *pb98TextField;
@property (weak, nonatomic) IBOutlet UITextField *onTextField;
@property (weak, nonatomic) IBOutlet UITextField *lpgTextField;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (weak, nonatomic) IBOutlet UIButton *addStationButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)addStationAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *actualPositionSwitch;

@end
