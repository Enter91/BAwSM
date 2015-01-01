//
//  LoginViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "UserInfo.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSDictionary *textViewInfoDict;
@property (strong, nonatomic) UITextField *firstResponderAfterInterfaceOrientationChange;
@property (nonatomic) BOOL keepActualViewFrame;
@property (nonatomic) CGRect keyboardFrameBeginRect;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
    
    [_titleLabel setText:NSLocalizedString(@"Login screen", nil)];
    [_loginLabel setText:NSLocalizedString(@"User", nil)];
    [_passwordLabel setText:NSLocalizedString(@"Password", nil)];
    [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [_titleLabel adjustsFontSizeToFitWidth];
    
    [_loginTextField setDelegate:self];
    [_passwordTextField setDelegate:self];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self setFramesForLandscape];
    } else {
        [self setFramesForPortrait];
    }
    
    _keepActualViewFrame = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[AmazingJSON sharedInstance] setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_parentView) {
        _parentView = nil;
    }
}

- (IBAction)loginAction:(id)sender {
    
    /*KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"mobi.byss.tests.iCarTools" accessGroup:nil];
    
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    keychainItem = nil;*/
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Please wait...", nil)];
    [[AmazingJSON sharedInstance] setDelegate:self];
    [[AmazingJSON sharedInstance] getResponseFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bawsm.comlu.com/loginUser.php?l=%@&p=%@", _loginTextField.text, _passwordTextField.text]]];
    
}

- (IBAction)registerAction:(id)sender {
    
    if (_parentView) {
        _parentView = nil;
    }
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(loginWantsRegisterUser)]) {
            [_delegate loginWantsRegisterUser];
        }
    }
    
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        [DejalBezelActivityView removeViewAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Login incorrect", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if ([[responseDict objectForKey:@"code"] intValue] == 201) {
        [DejalBezelActivityView removeViewAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Password incorrect", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"mobi.byss.tests.iCarTools" accessGroup:nil];
        [keychainItem resetKeychainItem];
        [keychainItem setObject:_passwordTextField.text forKey:(__bridge id)(kSecValueData)];
        [keychainItem setObject:_loginTextField.text forKey:(__bridge id)(kSecAttrAccount)];
        keychainItem = nil;
        
        NSDictionary *userInfo = [[responseDict objectForKey:@"response"] objectAtIndex:0];
        
        [[UserInfo sharedInstance] setUserInfoWithLogin:[[userInfo objectForKey:@"user_id"] intValue]
                                                  login:[userInfo objectForKey:@"login"]
                                              firstName:[userInfo objectForKey:@"first_name"]
                                               lastName:[userInfo objectForKey:@"last_name"]
                                               andEmail:[userInfo objectForKey:@"email"]];
        
        [DejalBezelActivityView removeViewAnimated:YES];
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(loginSuccess)]) {
                [_delegate loginSuccess];
            }
        }
        if (_parentView) {
            [self.revealViewController setFrontViewController:_parentView animated:YES];
            _parentView = nil;
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
        
        [_titleLabel setFrame:CGRectMake(8, 50, self.view.frame.size.width-16, 100)];
        [_titleLabel adjustsFontSizeToFitWidth];
        
        [_passwordLabel setFrame:CGRectMake(30, self.view.frame.size.height/2 + 8, 90, 30)];
        [_loginLabel setFrame:CGRectMake(30, self.view.frame.size.height/2 - 38, 90, 30)];
        
        float textFieldOriginX = _loginLabel.frame.origin.x + _loginLabel.frame.size.width + 8;
        [_loginTextField setFrame:CGRectMake(textFieldOriginX, _loginLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        [_passwordTextField setFrame:CGRectMake(textFieldOriginX, _passwordLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        
        [_loginButton setFrame:CGRectMake(30, _passwordTextField.frame.origin.y + _passwordTextField.frame.size.height + 15, self.view.frame.size.width - 60, 30)];
        CGPoint tmpPoint = _loginButton.center;
        [_loginButton sizeToFit];
        [_loginButton setCenter:tmpPoint];
        
        [_registerButton setFrame:CGRectMake(30, self.view.frame.size.height-45, self.view.frame.size.width-60, 30)];
        tmpPoint = _registerButton.center;
        [_registerButton sizeToFit];
        [_registerButton setCenter:tmpPoint];
    });
}

- (void)setFramesForLandscape {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
        
        [_titleLabel setFrame:CGRectMake(8, 8, self.view.frame.size.width-16, 50)];
        [_titleLabel adjustsFontSizeToFitWidth];
        
        [_passwordLabel setFrame:CGRectMake(30, self.view.frame.size.height/2.0 -15, 90, 30)];
        [_loginLabel setFrame:CGRectMake(30, _passwordLabel.frame.origin.y - 45, 90, 30)];
        
        
        float textFieldOriginX = _loginLabel.frame.origin.x + _loginLabel.frame.size.width + 8;
        
        [_loginTextField setFrame:CGRectMake(textFieldOriginX, _loginLabel.frame.origin.y, self.view.frame.size.width - textFieldOriginX - 30, 30)];
        [_passwordTextField setFrame:CGRectMake(textFieldOriginX, _passwordLabel.frame.origin.y, _loginTextField.frame.size.width, 30)];
        
        [_loginButton setFrame:CGRectMake(30, _passwordTextField.frame.origin.y + _passwordTextField.frame.size.height + 15, self.view.frame.size.width - 60, 30)];
        CGPoint tmpPoint = _loginButton.center;
        [_loginButton sizeToFit];
        [_loginButton setCenter:tmpPoint];
        
        [_registerButton setFrame:CGRectMake(30, self.view.frame.size.height-45, self.view.frame.size.width - 60, 30)];
        tmpPoint = _registerButton.center;
        [_registerButton sizeToFit];
        [_registerButton setCenter:tmpPoint];
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
    
    if (_firstResponderAfterInterfaceOrientationChange) {
        _firstResponderAfterInterfaceOrientationChange = nil;
    }
    
    if ([_loginTextField isFirstResponder]) {
        _firstResponderAfterInterfaceOrientationChange = _loginTextField;
        [_loginTextField resignFirstResponder];
    } else if ([_passwordTextField isFirstResponder]) {
        _firstResponderAfterInterfaceOrientationChange = _passwordTextField;
        [_passwordTextField resignFirstResponder];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_firstResponderAfterInterfaceOrientationChange) {
        [_firstResponderAfterInterfaceOrientationChange becomeFirstResponder];
        _firstResponderAfterInterfaceOrientationChange = nil;
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _textViewInfoDict = @{               @"tag": [NSNumber numberWithInt:(int)textField.tag],
                                         @"textField frame" : [NSValue valueWithCGRect:textField.frame]};
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    if (!CGRectIsNull(_keyboardFrameBeginRect)) {
        [self setViewMovement];
    }
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _keepActualViewFrame = NO;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    [self setViewMovement];
}

- (void)setViewMovement {
    CGRect textFieldFrame = [[_textViewInfoDict objectForKey:@"textField frame"] CGRectValue];
    int textFieldCenter = textFieldFrame.origin.y + textFieldFrame.size.height/2;
    
    int visibleViewSize = self.view.frame.size.height - _keyboardFrameBeginRect.size.height;
    int heightCenter = visibleViewSize / 2;
    
    int diff = textFieldCenter - heightCenter;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -1 * diff;
        self.view.frame = f;
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if (!_keepActualViewFrame) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = 0.0f;
            self.view.frame = f;
        } completion:^(BOOL finished) {
            _keepActualViewFrame = NO;
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        _keepActualViewFrame = YES;
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        _keepActualViewFrame = NO;
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark- Helpers
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    _keepActualViewFrame = NO;
    [self.view endEditing:YES];
}

- (BOOL) shouldAutorotate {
    return YES;
}

@end
