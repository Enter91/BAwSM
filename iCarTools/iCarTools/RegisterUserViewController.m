//
//  RegisterUserViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 01.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
    
    [_registrationLabel setText:NSLocalizedString(@"Registration2", nil)];
    [_loginLabel setText:NSLocalizedString(@"Login", nil)];
    [_passwordLabel setText:NSLocalizedString(@"Password", nil)];
    [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [_alreadyRegisteredButton setTitle:NSLocalizedString(@"I already have an account", nil) forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_registrationLabel adjustsFontSizeToFitWidth];
    
    [_loginTextField setDelegate:self];
    [_passwordTextField setDelegate:self];
    [_firstNameTextField setDelegate:self];
    [_lastNameTextField setDelegate:self];
    [_emailTextField setDelegate:self];
    
    self.revealViewController.panGestureRecognizer.enabled = NO;
    self.revealViewController.tapGestureRecognizer.enabled = NO;
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self setFramesForLandscape];
    } else {
        [self setFramesForPortrait];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[AmazingJSON sharedInstance] setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)registerAction:(id)sender {
    
    if (_loginTextField.text.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Login must be at least 4 characters long", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if (_passwordTextField.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Password must be at least 6 characters long", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if (_firstNameTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"First name cannot be empty", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if (_lastNameTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Last name cannot be empty", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if (_emailTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"E-mail cannot be empty", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if (![self NSStringIsValidEmail:_emailTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"E-mail is not correct", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else {
        
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Please wait...", nil)];
        [[AmazingJSON sharedInstance] setDelegate:self];
        [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/registerNewUser.php?l=%@&p=%@&fn=%@&ln=%@&email=%@", _loginTextField.text, _passwordTextField.text, _firstNameTextField.text, _lastNameTextField.text, _emailTextField.text]];
        
    }
}

- (IBAction)alreadyRegisteredAction:(id)sender {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(registerUserAlreadyRegistered)]) {
            [_delegate registerUserAlreadyRegistered];
        }
    }
}

- (IBAction)cancelAction:(id)sender {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(registerUserCancel)]) {
            [_delegate registerUserCancel];
        }
    }
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        [DejalBezelActivityView removeViewAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"This login exists", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if ([[responseDict objectForKey:@"code"] intValue] == 400 && [[responseDict objectForKey:@"response"] objectAtIndex:0]) {
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"mobi.byss.tests.iCarTools" accessGroup:nil];
        [keychainItem setObject:_passwordTextField.text forKey:(__bridge id)(kSecValueData)];
        [keychainItem setObject:_loginTextField.text forKey:(__bridge id)(kSecAttrAccount)];
        
        keychainItem = nil;
        
        NSDictionary *userInfo = [[responseDict objectForKey:@"response"] objectAtIndex:0];
        
        [[UserInfo sharedInstance] setUserInfoWithLogin:[[userInfo objectForKey:@"user_id"] intValue]
                                                  login:[userInfo objectForKey:@"login"]
                                              firstName:[userInfo objectForKey:@"first_name"]
                                               lastName:[userInfo objectForKey:@"last_name"]
                                               andEmail:[userInfo objectForKey:@"email"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [DejalBezelActivityView removeViewAnimated:YES];
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(registerUserSuccess)]) {
                [_delegate registerUserSuccess];
            }
        }
    } else {
        [DejalBezelActivityView removeViewAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Error occured. Please try again", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    
}

- (void)setFramesForPortrait {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
        
        [_registrationLabel setFrame:CGRectMake(8, 50, self.view.frame.size.width-16, 110)];
        [_registrationLabel adjustsFontSizeToFitWidth];
        
        [_firstNameLabel setFrame:CGRectMake(30, self.view.frame.size.height/2.0 - 15, 90, 30)];
        [_passwordLabel setFrame:CGRectMake(30, _firstNameLabel.frame.origin.y - 45, 90, 30)];
        [_loginLabel setFrame:CGRectMake(30, _passwordLabel.frame.origin.y - 45, 90, 30)];
        [_lastNameLabel setFrame:CGRectMake(30, _firstNameLabel.frame.origin.y + _firstNameLabel.frame.size.height + 15, 90, 30)];
        [_emailLabel setFrame:CGRectMake(30, _lastNameLabel.frame.origin.y + _lastNameLabel.frame.size.height + 15, 90, 30)];
        
        
        float textFieldOriginX = _loginLabel.frame.origin.x + _loginLabel.frame.size.width + 8;
        [_loginTextField setFrame:CGRectMake(textFieldOriginX, _loginLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        [_passwordTextField setFrame:CGRectMake(textFieldOriginX, _passwordLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        [_firstNameTextField setFrame:CGRectMake(textFieldOriginX, _firstNameLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        [_lastNameTextField setFrame:CGRectMake(textFieldOriginX, _lastNameLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        [_emailTextField setFrame:CGRectMake(textFieldOriginX, _emailLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        
        [_registerButton setFrame:CGRectMake(30, _emailTextField.frame.origin.y + _emailTextField.frame.size.height + 15, self.view.frame.size.width - 60, 30)];
        CGPoint tmpPoint = _registerButton.center;
        [_registerButton sizeToFit];
        [_registerButton setCenter:tmpPoint];
        
        [_cancelButton setFrame:CGRectMake(30, self.view.frame.size.height-45, self.view.frame.size.width-60, 30)];
        tmpPoint = _cancelButton.center;
        [_cancelButton sizeToFit];
        [_cancelButton setCenter:tmpPoint];
        [_alreadyRegisteredButton setFrame:CGRectMake(30, _cancelButton.frame.origin.y-38, self.view.frame.size.width-60, 30)];
        tmpPoint = _alreadyRegisteredButton.center;
        [_alreadyRegisteredButton sizeToFit];
        [_alreadyRegisteredButton setCenter:tmpPoint];
    });
}

- (void)setFramesForLandscape {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
        
        [_registrationLabel setFrame:CGRectMake(8, 0, self.view.frame.size.width-16, 110)];
        [_registrationLabel adjustsFontSizeToFitWidth];
        
        [_passwordLabel setFrame:CGRectMake(8, 110+50, 90, 30)];
        [_loginLabel setFrame:CGRectMake(8, _passwordLabel.frame.origin.y - 45, 90, 30)];
        [_firstNameLabel setFrame:CGRectMake(8, _passwordLabel.frame.origin.y + 45, 90, 30)];
        [_lastNameLabel setFrame:CGRectMake(self.view.frame.size.width/2.0, _loginLabel.frame.origin.y, 90, 30)];
        [_emailLabel setFrame:CGRectMake(self.view.frame.size.width/2.0, _passwordLabel.frame.origin.y, 90, 30)];
        
        float textFieldOriginX = _loginLabel.frame.origin.x + _loginLabel.frame.size.width + 8;
        float textFieldSecondColumnOriginY = self.view.frame.size.width/2.0 + textFieldOriginX - 8;
        
        [_loginTextField setFrame:CGRectMake(textFieldOriginX, _loginLabel.frame.origin.y, self.view.frame.size.width/2.0 - textFieldOriginX - 8, 30)];
        [_passwordTextField setFrame:CGRectMake(textFieldOriginX, _passwordLabel.frame.origin.y, _loginTextField.frame.size.width, 30)];
        [_firstNameTextField setFrame:CGRectMake(textFieldOriginX, _firstNameLabel.frame.origin.y, _loginTextField.frame.size.width, 30)];
        [_lastNameTextField setFrame:CGRectMake(textFieldSecondColumnOriginY, _lastNameLabel.frame.origin.y, self.view.frame.size.width/2.0 - textFieldOriginX, 30)];
        [_emailTextField setFrame:CGRectMake(textFieldSecondColumnOriginY, _emailLabel.frame.origin.y, self.view.frame.size.width/2.0 - textFieldOriginX, 30)];
        
        [_registerButton setFrame:CGRectMake(30, _firstNameTextField.frame.origin.y + _firstNameTextField.frame.size.height + 15, self.view.frame.size.width - 60, 30)];
        CGPoint tmpPoint = _registerButton.center;
        [_registerButton sizeToFit];
        [_registerButton setCenter:tmpPoint];
        
        [_alreadyRegisteredButton setFrame:CGRectMake(30, self.view.frame.size.height-35, self.view.frame.size.width/2.0 - 45, 30)];
        tmpPoint = _alreadyRegisteredButton.center;
        [_alreadyRegisteredButton sizeToFit];
        [_alreadyRegisteredButton setCenter:tmpPoint];
        
        [_cancelButton setFrame:CGRectMake(self.view.frame.size.width/2 + 15, _alreadyRegisteredButton.frame.origin.y, self.view.frame.size.width/2.0 - 45, 30)];
        tmpPoint = _cancelButton.center;
        [_cancelButton sizeToFit];
        [_cancelButton setCenter:tmpPoint];
    });
}



#pragma mark- UINavigationController Delegates
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
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
            [self setFramesForLandscape];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self setFramesForLandscape];
            break;
            
        default:
            break;
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark- TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark- Helpers
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.navigationController.navigationBar endEditing:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL) shouldAutorotate {
    return YES;
}

@end
