//
//  RecorderViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSUtilities.h"

@import MobileCoreServices;

@protocol RecorderViewControllerDelegate <NSObject>

- (void)recorderViewWantsDismiss;

@end

@interface RecorderViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, GPSUtilitiesDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) UIImagePickerController *pickerController;

@property (strong, nonatomic) UIButton *cameraRecordingButton;
@property (strong, nonatomic) UIButton *speedNotificationButton;
@property (strong, nonatomic) UIButton *crashNotificationButton;
@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *exitButton;

@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *speedUnitsLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *recordedTimeLabel;

@property (strong, nonatomic) UIView *lowerBackgroundView;
@property (strong, nonatomic) UIView *upperBackgroundView;

@property (strong, nonatomic) UIImageView *smallDotImageView;

@property (strong, nonatomic) UIImageView *gpsStatusImageView;

@property (strong, nonatomic) GPSUtilities *gpsUtilities;

@property BOOL isRecording;

@property (nonatomic, assign) id delegate;

@end
