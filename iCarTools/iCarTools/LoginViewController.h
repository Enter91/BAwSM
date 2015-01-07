//
//  LoginViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 22.11.2014.
//  Copyright (c) 2014 Damian Klimaszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginManager.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginSuccess;
- (void)loginWantsRegisterUser;

@end

/*!
 * @author Damian Klimaszewski
 * @discussion Kontroler umożliwiający zalogowanie się użytkownika poprzez podanie loginu i hasła.
 */
@interface LoginViewController : UIViewController <UITextFieldDelegate, LoginManagerDelegate, UINavigationControllerDelegate>

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
 * @discussion Przycisk uruchamiający akcję logowania. Wywołuje metodę loginAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/*!
 *  @Author Damian Klimaszewski
 *
 *  @discussion Akcja logowania. Przesyła zapytanie z podanym loginem i hasłem
 *
 */
- (IBAction)loginAction:(id)sender;

/*!
 * @author Damian Klimaszewski
 * @discussion Przycisk uruchamiający akcję wyświetlenia kontrolera rejestracji. Wywołuje metodę registerAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

/*!
 *  @Author Damian Klimaszewski
 *
 *  @discussion Otwiera RegisterUserViewController
 *
 */
- (IBAction)registerAction:(id)sender;

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
 * @discussion Labelka z wycentrowanym tytułem kontrolera
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/*!
 * @author Damian Klimaszewski
 * @discussion Delegat klasy LoginViewController
 */
@property (nonatomic, assign) id delegate;

@end
