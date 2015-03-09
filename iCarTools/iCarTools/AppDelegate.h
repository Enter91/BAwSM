//
//  AppDelegate.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>
//#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "TutorialViewController.h"
#import "RecorderViewController.h"
//#import "StatsViewController.h"
//#import "RegisterUserViewController.h"
//#import "LoginManager.h"
#import "RecorderViewController.h"

@class SWRevealViewController;
@class RecorderViewController;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Główny delegat aplikacji. Jest to pierwsza klasa wywoływana z main.m po starcie aplikacji
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate, SWRevealViewControllerDelegate, TutorialViewControllerDelegate>

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Główne okno aplikacji
 */
@property (strong, nonatomic) UIWindow *window;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Kontroler wyświetlający boczne menu oraz główny kontroler
 */
@property (strong, nonatomic) SWRevealViewController *viewController;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Kontroler widoku tutoriala uruchamianego przy pierwszym uruchomieniu aplikacji.
 */
@property (strong, nonatomic) TutorialViewController *tutorial;

@property (strong, nonatomic) RecorderViewController *recorderViewController;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Kontroler widoku logowania
 */
//@property (strong, nonatomic) LoginViewController *loginViewController;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Kontroler widoku rejestracji
 */
//@property (strong, nonatomic) RegisterUserViewController *registerUserViewController;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Klasa zarządzająca danymi zalogowanego użytkownika
 */
//@property (strong, nonatomic) LoginManager *loginManager;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Flaga określająca, czy orientacja ekranu ma być zablokowana. Umożliwia blokadę w dowolnym momencie z innego kontrolera.
 */
@property (nonatomic) BOOL orientationIsLocked;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Orientacja, w jakiej flaga orientationIsLocked została ustawiona na wartość YES.
 */
@property (nonatomic) NSUInteger lockedOrientation;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Wyświetla ekran logowania jako główny kontroler.
 */
- (void)showLoginViewScreen;

@end

