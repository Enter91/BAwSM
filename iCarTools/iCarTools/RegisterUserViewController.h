//
//  RegisterUserViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 01.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmazingJSON.h"
#import "UserInfo.h"
#import "KeychainItemWrapper.h"

@protocol RegisterUserViewControllerDelegate <NSObject>

- (void)registerUserSuccess;
- (void)registerUserAlreadyRegistered;
- (void)registerUserCancel;

@end

@interface RegisterUserViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, AmazingJSONDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadyRegisteredButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)registerAction:(id)sender;
- (IBAction)alreadyRegisteredAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@property (nonatomic, assign) id delegate;

@end
