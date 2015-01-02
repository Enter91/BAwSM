//
//  LoginManager.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 02.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmazingJSON.h"
#import "UserInfo.h"
#import "KeychainItemWrapper.h"

@protocol LoginManagerDelegate <NSObject>

- (void)loginManagerSuccess;
- (void)loginManagerFailWithErrorMessage:(NSString *)errorMessage;

@end

@interface LoginManager : NSObject <AmazingJSONDelegate>

/**
 *  @Author Michał Czwarnowski
 *
 *  Loguje użytkownika danymi zapisanymi w Keychain
 */
- (void)loginUser;

/**
 *  @Author Michał Czwarnowski
 *
 *  Loguje użytkownika podanym loginem i hasłem
 *
 *  @param login    login wpisany w pole tekstowe
 *  @param password hasło wpisane w pole tekstowe
 */
- (void)loginUserWithLogin:(NSString *)login andPassword:(NSString *)password;

/**
 *  @Author Michał Czwarnowski
 *
 *  Wylogowanie użytkownika wraz z usunięciem danych z Keychain
 */
- (void)logoutUser;

@property (nonatomic, assign) id delegate;

@end
