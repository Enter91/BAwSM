//
//  LoginViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SBJson4.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
- (IBAction)forgotPasswordAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end
