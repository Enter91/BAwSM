//
//  TutorialViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GPSUtilities.h"

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Protokół klasy TutorialViewController
 */
@protocol TutorialViewControllerDelegate <NSObject>

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Informuje delegat o zakończeniu wyświetlania tutoriala. Uruchamiana po przejściu przez wszystkie stany.
 *
 *  @param wantsRegister Flaga określająca, czy użytkownik chce się zarejestrować.
 */
- (void)didEndTutorialWithRegistration:(BOOL)wantsRegister;

@end

/*!
 * @author Michał Czwarnowski
 * @brief  Klasa wyświetlająca ekran powitalny oraz sprawdzająca dostęp do poszczególnych sensorów i uprawnień.
 */
@interface TutorialViewController : UIViewController <UINavigationControllerDelegate>

/*!
 * @author Michał Czwarnowski
 * @brief  Delegat klasy TutorialViewController
 */
@property (nonatomic, assign) id delegate;

@end
