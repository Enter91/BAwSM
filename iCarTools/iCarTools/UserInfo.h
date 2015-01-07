//
//  UserInfo.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 01.01.2015.
//  Copyright (c) 2015 Damian Klimaszewski. All rights reserved.
//

@import Foundation;

/*!
 *  @Author Damian Klimaszewski
 *
 *  @brief  Klasa zarządzająca danymi o zalogowanym użytkowniku
 */
@interface UserInfo : NSObject

/*!
 * gets singleton object.
 * @return singleton
 */
+ (UserInfo*)sharedInstance;

/*!
 *  @Author Damian Klimaszewski
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

/*!
 *  @Author Damian Klimaszewski
 *
 *  Czyści zapisane dane użytkownika
 */
- (void)clearAllData;

/*!
 *  @Author Damian Klimaszewski
 *
 *  ID użytkownika w bazie
 */
@property (nonatomic) int user_id;

/*!
 *  @Author Damian Klimaszewski
 *
 *  Login użytkownika
 */
@property (strong, nonatomic) NSString *login;

/*!
 *  @Author Damian Klimaszewski
 *
 *  Imię użytkownika
 */
@property (strong, nonatomic) NSString *first_name;

/*!
 *  @Author Damian Klimaszewski
 *
 *  Nazwisko użytkownika
 */
@property (strong, nonatomic) NSString *last_name;

/*!
 *  @Author Damian Klimaszewski
 *
 *  Adres e-mail użytkownika
 */
@property (strong, nonatomic) NSString *email;


@end
