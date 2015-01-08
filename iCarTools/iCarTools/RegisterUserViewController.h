//
//  RegisterUserViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 01.01.2015.
//  Copyright (c) 2015 Damian Klimaszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmazingJSON.h"
#import "UserInfo.h"
#import "KeychainItemWrapper.h"

/*!
 *  @author Damian Klimaszewski
 *
 *  @brief  Protokół klasy RegisterUserViewController.
 */
@protocol RegisterUserViewControllerDelegate <NSObject>

/*!
 *  @author Damian Klimaszewski
 *
 *  @brief  Rejestracja zakończona pomyślnie
 */
- (void)registerUserSuccess;

/*!
 *  @author Damian Klimaszewski
 *
 *  @brief  Użytkownik już zarejestrowany. Delegat klasy powinien wyświetlić ekran logowania.
 */
- (void)registerUserAlreadyRegistered;

/*!
 *  @author Damian Klimaszewski
 *
 *  @brief  Użytkownik zrezygnował z rejestracji
 */
- (void)registerUserCancel;

@end

/*!
 * @author Damian Klimaszewski
 * @discussion Kontroler umożliwiający rejestrację użytkownika.
 */
@interface RegisterUserViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, AmazingJSONDelegate>

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe do wpisania loginu
 */
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe do wpisania hasła
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe do wpisania imienia
 */
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe do wpisania nazwiska
 */
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Pole tekstowe do wpisania e-maila
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk uruchamiający akcję rejestracji. Wywołuje metodę registerAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk uruchamiający akcję wyświetlenia kontrolera logowania. Wywołuje metodę alreadyRegisteredAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *alreadyRegisteredButton;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk uruchamiający akcję zamknięcia ekranu rejestracji. Wywołuje metodę cancelAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/*!
 * @author Damian Klimaszewski
 * @discussion Labelka z wycentrowanym tytułem kontrolera
 */
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Labelka z opisem pola do wpisania loginu
 */
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Labelka z opisem pola do wpisania hasła
 */
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Labelka z opisem pola do wpisania imienia
 */
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Labelka z opisem pola do wpisania nazwiska
 */
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Labelka z opisem pola do wpisania e-maila
 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Image View ustawiony jako tło kontrolera
 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

/*!
 *
 *  @Author Damian Klimaszewski
 *
 *  @discussion Akcja wywołuje połączenie z bazą danych w celu zarejestrowania użytkownika
 *
 *  @param  sender Obiekt wywołujący akcję
 */
- (IBAction)registerAction:(id)sender;

/*!
 *  @Author Damian Klimaszewski
 *
 *  @discussion Akcja otwarcia widoku logowania
 *
 *  @param  sender Obiekt wywołujący akcję
 */
- (IBAction)alreadyRegisteredAction:(id)sender;

/*!
 *  @Author Damian Klimaszewski
 *
 *  @discussion Akcja zamknięcia okna rejestracji. Umożliwia powrót do głównego menu lub ostatnio otwartego kontrolera.
 *
 *  @param  sender Obiekt wywołujący akcję
 */
- (IBAction)cancelAction:(id)sender;

/*!
 * @author Damian Klimaszewski
 * @discussion Delegat klasy RegisterUserViewController
 */
@property (nonatomic, assign) id delegate;

@end
