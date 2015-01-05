//
//  LoginViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginManager.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginSuccess;
- (void)loginWantsRegisterUser;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate, LoginManagerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) id delegate;

//@property (nonatomic, strong) UIViewController *parentView;

@property (strong, nonatomic) LoginManager *loginManager;

@end
