//
//  SettingsViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>
#import "LoginManager.h"
#import "LoginViewController.h"

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Delegat klasy SettingsViewController. Przekazuje poziom menu i numer klikniętej opcji. Informuje delegat o zamknięciu widoku przez użytkownika.
 */
@protocol SettingsViewControllerDelegate <NSObject>

@required
/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Przekazuje do delegata informację o poziomie menu i indeksie klikniętej komórki w UITableView
 *
 *  @param number   Indeks komórki
 *  @param menuType Poziom menu
 */
- (void)clickedOption:(int)number inMenuType:(int)menuType;

@optional
/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Informuje delegat o tym, że widok zostanie zamknięty.
 */
- (void)settingsViewWillDisappear;

@end

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  SettingsViewController prezentuje listę opcji wykorzystując UITableView a także wyświetla informacje o aktualnie zalogowanym użytkowniku.
 */
@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Inicjalizuje obiekt klasy SettingsViewController z podaną tablicą opcji, które mają być wyświetlone
 *
 *  @param titlesArray Tablica zawierająca obiekty typu NSString, które mają być wyświetlone na liście
 *
 *  @return Zainicjalizowany obiekt klasy SettingsView Controller
 */
- (id)initWithCellsTitlesArray:(NSArray *)titlesArray;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  TableView wyświetlający opcje w kolejnych komórkach tabeli
 */
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Widok prezentujący informacje o aktualnie zalogowanym użytkowniku oraz przycisk wylogowania. W przypadku, gdy użytkownik nie jest zalogowany wyświetlony jest przycisk umożliwiający zalogowanie.
 */
@property (weak, nonatomic) IBOutlet UIView *loginInfoView;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Labelka wyświetlająca imię i nazwisko użytkownika
 */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Aktualizuje widoczne menu
 *
 *  @param titlesArray Tablica zawierająca obiekty typu NSString, które mają być wyświetlone na liście
 */
- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Aktualizuje widoczne menu pozwalając wybrać aktualny poziom wielopoziomowego menu
 *
 *  @param titlesArray Tablica zawierająca obiekty typu NSString, które mają być wyświetlone na liście
 *  @param depth       Poziom menu
 */
- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray andMenuType:(int)depth;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Aktualizuje widoczne menu pozwalając wybrać aktualny poziom wielopoziomowego menu. Umożliwia zaznaczenie aktywnej opcji
 *
 *  @param titlesArray Tablica zawierająca obiekty typu NSString, które mają być wyświetlone na liście
 *  @param activeIndex Index opcji, która ma być oznaczona jako aktywna
 *  @param depth       Poziom menu
 */
- (void)updateMenuWithTitlesArray:(NSArray *)titlesArray indexOfActiveOption:(int)activeIndex andMenuType:(int)depth;

/*!
 * @author Michał Czwarnowski
 * @discussion Delegat klasy SettingsViewController
 */
@property (nonatomic, assign) id delegate;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Ustawia tekst prezentujący informacje o aktualnie zalogowanym użytkowniku
 *
 *  @param labelText Tekst wyświetlany jako informacje o aktualnie zalogowanym użytkowniku
 */
- (void)setUserInfoWithName:(NSString *)labelText;

@end
