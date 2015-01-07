//
//  RecorderViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSUtilities.h"
@import AVFoundation;
@import AssetsLibrary;
@import MobileCoreServices;

#import "LoginViewController.h"
#import <SWRevealViewController.h>

#import "SettingsViewController.h"
#import "AmazingJSON.h"
#import "AppDelegate.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "RecordedVideosViewController.h"
#import "UIImage+Resizing.h"
#import "DejalActivityView.h"
#import "NSBag.h"

@interface RecorderViewController : UIViewController <UINavigationControllerDelegate, GPSUtilitiesDelegate, AVCaptureFileOutputRecordingDelegate, SettingsViewControllerDelegate, AmazingJSONDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;

/**
 *  @Author Michał Czwarnowski
 *
 *  Określa stan nagrywania
 */
@property BOOL isRecording;

/**
 *  @Author Michał Czwarnowski
 *
 *  Widok, z którego został uruchomiony RecorderViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

/**
 *  @Author Michał Czwarnowski
 *
 *  Flaga określająca, czy kontroler żąda customowej animacji uruchamianej z SWRevealController
 */
@property (nonatomic) BOOL wantsCustomAnimation;

/**
 *  @Author Michał Czwarnowski
 *
 *  Inicjalizuje kamerę oraz uruchamia jej podgląd
 */
- (void)initializeCamera;

/**
 *  @Author Michał Czwarnowski
 *
 *  Zatrzymuje nagranie (jeżeli kamera aktualnie nagrywa), sesję kamery oraz usuwa widok
 */
- (void)stopCamera;

@end
