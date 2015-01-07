//
//  UserInfo.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 01.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

@import Foundation;

@interface UserInfo : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (UserInfo*)sharedInstance;

/**
 *  @Author Michał Czwarnowski
 *
 *  Ustawia dane logowanego użytkownika
 *
 *  @param user_id   ID użytkownika w bazie danych
 *  @param login     Login użytkownika
 *  @param firstName Imię użytkownika
 *  @param lastName  Nazwisko użytkownika
 *  @param email     Adres e-mail użytkownika
 */
- (void)setUserInfoWithLogin:(int)user_id login:(NSString *)login firstName:(NSString *)firstName lastName:(NSString *)lastName andEmail:(NSString *)email;

/**
 *  @Author Michał Czwarnowski
 *
 *  Czyści zapisane dane użytkownika
 */
- (void)clearAllData;

/**
 *  @Author Michał Czwarnowski
 *
 *  ID użytkownika w bazie
 */
@property (nonatomic) int user_id;

/**
 *  @Author Michał Czwarnowski
 *
 *  Login użytkownika
 */
@property (strong, nonatomic) NSString *login;

/**
 *  @Author Michał Czwarnowski
 *
 *  Imię użytkownika
 */
@property (strong, nonatomic) NSString *first_name;

/**
 *  @Author Michał Czwarnowski
 *
 *  Nazwisko użytkownika
 */
@property (strong, nonatomic) NSString *last_name;

/**
 *  @Author Michał Czwarnowski
 *
 *  Adres e-mail użytkownika
 */
@property (strong, nonatomic) NSString *email;


@end
