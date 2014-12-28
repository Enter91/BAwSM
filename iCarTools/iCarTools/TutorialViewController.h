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

@interface TutorialViewController : UIViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *iPhoneImageView;

@property (strong, nonatomic) UILabel *permissionTitle;
@property (strong, nonatomic) UILabel *permissionDescription;
@property (strong, nonatomic) UIButton *permissionButton;

@property (nonatomic, assign) id delegate;

- (void)recoverCurrentState;

@end
