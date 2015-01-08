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

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Protokół klasy LoginManager.
 */
@protocol LoginManagerDelegate <NSObject>

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Metoda informująca delegat o udanym logowaniu.
 */
- (void)loginManagerSuccess;

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Metoda informująca delegat o błędzie w trakcie logowania
 *
 *  @param errorMessage Komunikat błędu
 */
- (void)loginManagerFailWithErrorMessage:(NSString *)errorMessage;

@end

/*!
 *  @Author Michał Czwarnowski
 *
 *  @discussion Klasa umożliwiająca logowanie oraz wylogowanie użytkownika. Logowanie możliwe jest na dwa sposoby - automatycznie z danych zapisanych w Keychain lub poprzez podanie loginu i hasła.
 */
@interface LoginManager : NSObject <AmazingJSONDelegate>

/*!
 *  @Author Michał Czwarnowski
 *
 *  @discussion Loguje użytkownika danymi zapisanymi w Keychain
 */
- (void)loginUser;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @discussion Loguje użytkownika podanym loginem i hasłem
 *
 *  @param login    login wpisany w pole tekstowe
 *  @param password hasło wpisane w pole tekstowe
 */
- (void)loginUserWithLogin:(NSString *)login andPassword:(NSString *)password;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @discussion Wylogowanie użytkownika wraz z usunięciem danych z Keychain
 */
- (void)logoutUser;

/*!
 * @author Michał Czwarnowski
 * @discussion Delegat klasy LoginManager
 */
@property (nonatomic, assign) id delegate;

@end
