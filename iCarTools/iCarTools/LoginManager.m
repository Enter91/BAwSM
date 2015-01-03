//
//  LoginManager.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 02.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "LoginManager.h"

@interface LoginManager ()

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *username;

@end

@implementation LoginManager

- (void)loginUser {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"mobi.byss.tests.iCarTools" accessGroup:nil];
    
    if ([keychainItem objectForKey:(__bridge id)(kSecValueData)] && [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)]) {
        _password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        _username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
        
        if (_username.length<=0 && _password.length<=0) {
            if (_delegate) {
                if ([_delegate respondsToSelector:@selector(loginManagerFailWithErrorMessage:)]) {
                    [_delegate loginManagerFailWithErrorMessage:NSLocalizedString(@"Can't login. Please try again.", nil)];
                }
            }
            
            return;
        }
        
        keychainItem = nil;
        
        [[AmazingJSON sharedInstance] setDelegate:self];
        [[AmazingJSON sharedInstance] getResponseFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bawsm.comlu.com/loginUser.php?l=%@&p=%@", _username, _password]]];
    } else {
        
    }

}

- (void)loginUserWithLogin:(NSString *)login andPassword:(NSString *)password {
    
    if (login.length > 0 && password.length > 0) {
        _password = [NSString stringWithString:password];
        _username = [NSString stringWithString:login];
        
        [[AmazingJSON sharedInstance] setDelegate:self];
        [[AmazingJSON sharedInstance] getResponseFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bawsm.comlu.com/loginUser.php?l=%@&p=%@", _username, _password]]];
    } else {
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(loginManagerFailWithErrorMessage:)]) {
                [_delegate loginManagerFailWithErrorMessage:NSLocalizedString(@"Can't login. Please try again.", nil)];
            }
        }
    }
    
}

- (void)logoutUser {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"mobi.byss.tests.iCarTools" accessGroup:nil];
    [keychainItem resetKeychainItem];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UserInfo sharedInstance] clearAllData];
    
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    
    [[AmazingJSON sharedInstance] setDelegate:nil];
    
    if ([[responseDict objectForKey:@"code"] intValue] == 200) {
        
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(loginManagerFailWithErrorMessage:)]) {
                [_delegate loginManagerFailWithErrorMessage:NSLocalizedString(@"Login incorrect", nil)];
            }
        }
        
    } else if ([[responseDict objectForKey:@"code"] intValue] == 201) {
        
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(loginManagerFailWithErrorMessage:)]) {
                [_delegate loginManagerFailWithErrorMessage:NSLocalizedString(@"Password incorrect", nil)];
            }
        }
        
    } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"mobi.byss.tests.iCarTools" accessGroup:nil];
        [keychainItem resetKeychainItem];
        [keychainItem setObject:_password forKey:(__bridge id)(kSecValueData)];
        [keychainItem setObject:_username forKey:(__bridge id)(kSecAttrAccount)];
        keychainItem = nil;
        
        NSDictionary *userInfo = [[responseDict objectForKey:@"response"] objectAtIndex:0];
        
        [[UserInfo sharedInstance] setUserInfoWithLogin:[[userInfo objectForKey:@"user_id"] intValue]
                                                  login:[userInfo objectForKey:@"login"]
                                              firstName:[userInfo objectForKey:@"first_name"]
                                               lastName:[userInfo objectForKey:@"last_name"]
                                               andEmail:[userInfo objectForKey:@"email"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(loginManagerSuccess)]) {
                [_delegate loginManagerSuccess];
            }
        }
        
    } else {
        
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(loginManagerFailWithErrorMessage:)]) {
                [_delegate loginManagerFailWithErrorMessage:NSLocalizedString(@"Error occured. Please try again", nil)];
            }
        }
        
    }
    
}

@end
