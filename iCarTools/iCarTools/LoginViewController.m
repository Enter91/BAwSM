//
//  LoginViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_loginLabel setText:NSLocalizedString(@"User", nil)];
    [_passwordLabel setText:NSLocalizedString(@"Password", nil)];
    [_registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [_forgotPasswordButton setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateNormal];
    [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(id)sender {
    
    //TODO: Zmienić na PHP z logowania
    [[AmazingJSON sharedInstance] setDelegate:self];
    [[AmazingJSON sharedInstance] getResponseFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bawsm.comuf.com/checkUser.php?login=%@&password=%@", _loginTextField.text, _passwordTextField.text]]];
    
}

- (IBAction)registerAction:(id)sender {
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    [[AmazingJSON sharedInstance] getResponseFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bawsm.comuf.com/checkUser.php?login=%@&password=%@", _loginTextField.text, _passwordTextField.text]]];
    
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    NSLog(@"response: %@", responseDict);
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [responseDict objectForKey:@"response"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

- (IBAction)forgotPasswordAction:(id)sender {
}
@end
