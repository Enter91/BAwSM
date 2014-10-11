//
//  ViewController.h
//  Wideo Rejestrator
//
//  Created by Michał Czwarnowski on 06.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MobileCoreServices;

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) UIImagePickerController *pickerController;

@property (strong, nonatomic) UIButton *cameraRecordingButton;
@property (strong, nonatomic) UIButton *speedNotificationButton;
@property (strong, nonatomic) UIButton *crashNotificationButton;
@property (strong, nonatomic) UIButton *menuButton;

@property (strong, nonatomic) UILabel *speedLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *recordedTimeLabel;

@property (strong, nonatomic) UIView *lowerBackgroundView;
@property (strong, nonatomic) UIView *upperBackgroundView;

@property (strong, nonatomic) UIImageView *smallDotImageView;

@property (strong, nonatomic) UIImageView *gpsStatusImageView;

@property BOOL isRecording;

@end

