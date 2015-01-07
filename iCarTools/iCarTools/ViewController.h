//
//  ViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecorderViewController.h"
#import "StatsViewController.h"
#import <SWRevealViewController.h>
#import "CustomAnimationController.h"

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Główne menu aplikacji
 */
@interface ViewController : UIViewController <UINavigationControllerDelegate, SWRevealViewControllerDelegate>

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Główny widok kontrolera
 */
@property (strong, nonatomic) IBOutlet UIView *view;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Przycisk wywołujący akcję videoRecorderOpenAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *videoRecorderOpenButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Przycisk wywołujący akcję statsOpenAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *statsOpenButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Przycisk wywołujący akcję settingsOpenAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *settingsOpenButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Wycentrowana labelka z nazwą aplikacji
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Przycisk nałożony na obrazek videoImage wywołujący akcję videoRecorderOpenAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *videoRecorderOpenImageButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Przycisk nałożony na obrazek statsImage wywołujący akcję statsOpenAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *statsOpenImageButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Przycisk nałożony na obrazek settingsImage wywołujący akcję settingsOpenAction:
 */
@property (weak, nonatomic) IBOutlet UIButton *settingsOpenImageButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  ImageView wyświetlający obrazek odpowiadający kontrolerowi RecorderViewController
 */
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  ImageView wyświetlający obrazek odpowiadający kontrolerowi StatsViewController
 */
@property (weak, nonatomic) IBOutlet UIImageView *statsImage;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  ImageView wyświetlający obrazek odpowiadający kontrolerowi SettingsViewController
 */
@property (weak, nonatomic) IBOutlet UIImageView *settingsImage;

/*!
 * @author Michał Czwarnowski
 * @brief  Image View ustawiony jako tło kontrolera
 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageview;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Obiekt klasy RecorderViewController uruchamiany z głównego menu
 */
@property (strong, nonatomic) RecorderViewController *recorderView;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Obiekt klasy StatsViewController uruchamiany z głównego menu
 */
@property (strong, nonatomic) StatsViewController *statsView;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Akcja ustawienia obiektu klasy RecorderViewController jako front view controllera
 *
 */
- (IBAction)videoRecorderOpenAction:(id)sender;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Akcja ustawienia obiektu klasy StatsViewController jako front view controllera
 *
 */
- (IBAction)statsOpenAction:(id)sender;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Akcja wysunięcia rear view controllera
 *
 */
- (IBAction)settingsOpenAction:(id)sender;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Okno aplikacji
 */
@property (strong, nonatomic) UIWindow *window;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Flaga określająca, czy kontroler żąda customowej animacji uruchamianej z SWRevealController
 */
@property (nonatomic) BOOL wantsCustomAnimation;

@end
