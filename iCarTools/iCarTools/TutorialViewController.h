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

@protocol TutorialViewControllerDelegate <NSObject>

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
