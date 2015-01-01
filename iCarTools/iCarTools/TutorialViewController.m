//
//  TutorialViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 22.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "TutorialViewController.h"
#import "AppDelegate.h"

@interface TutorialViewController () {
    int currentState;
    __block BOOL runningAnimation;
}

@end

@implementation TutorialViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        currentState = 0;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.orientationIsLocked = YES;
        appDelegate.lockedOrientation = UIInterfaceOrientationMaskPortrait;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentState = 0;
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-Background"]];
    [_backgroundImageView setFrame:CGRectMake(0, 0, self.view.frame.size.height*(256.0/160.0), self.view.frame.size.height)];
    [_backgroundImageView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [self.view addSubview:_backgroundImageView];
    
    _iPhoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-iPhone"]];
    [_iPhoneImageView setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.height * 0.75 * 763.0/1602.0, self.view.frame.size.height * 0.75)];
    [_iPhoneImageView setCenter:CGPointMake(_iPhoneImageView.center.x, self.view.center.y)];
    [self.view addSubview:_iPhoneImageView];
    
    _permissionTitle = [[UILabel alloc] init];
    [_permissionTitle setFont:[UIFont fontWithName:@"DINPro-Light" size:30.0]];
    [_permissionTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    [_permissionTitle setTextColor:[UIColor whiteColor]];
    [_permissionTitle setTextAlignment:NSTextAlignmentCenter];
    [_permissionTitle setText:NSLocalizedString(@"Tutorial1Title", nil)];
    [_permissionTitle setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height*0.125)];
    [self.view addSubview:_permissionTitle];
    
    _permissionDescription = [[UILabel alloc] init];
    [_permissionDescription setFont:[UIFont fontWithName:@"DINPro-Light" size:18.0]];
    [_permissionDescription setNumberOfLines:0];
    [_permissionDescription setLineBreakMode:NSLineBreakByTruncatingTail];
    [_permissionDescription setTextColor:[UIColor whiteColor]];
    [_permissionDescription setTextAlignment:NSTextAlignmentCenter];
    [_permissionDescription setText:NSLocalizedString(@"Tutorial1", nil)];
    [_permissionDescription setFrame:CGRectMake(10.0, _iPhoneImageView.frame.origin.y + 10, self.view.frame.size.width - 120, _iPhoneImageView.frame.size.height - 20)];
    [self.view addSubview:_permissionDescription];
    
    _permissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_permissionButton setBackgroundColor:[UIColor colorWithRed:0.01 green:0.82 blue:0.31 alpha:1]];
    [_permissionButton.titleLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:20.0]];
    [_permissionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_permissionButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [_permissionButton.layer setCornerRadius:5.0];
    
    [_permissionButton setFrame:CGRectMake(0.0, _permissionTitle.frame.size.height + _iPhoneImageView.frame.size.height + 15.0, self.view.frame.size.width * 0.75, self.view.frame.size.height - (_permissionTitle.frame.size.height + _iPhoneImageView.frame.size.height + 15.0) - 15.0)];
    [_permissionButton setCenter:CGPointMake(self.view.center.x, _permissionButton.center.y)];
    [_permissionButton setUserInteractionEnabled:NO];
    [_permissionButton addTarget:self action:@selector(goToNextState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_permissionButton];
    _permissionButton.alpha = 0.0;

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    CGRect iPhoneFrame = _iPhoneImageView.frame;
    iPhoneFrame.origin.x = iPhoneFrame.origin.x - 100;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_iPhoneImageView setFrame:iPhoneFrame];
    } completion:^(BOOL finished) {
        [_iPhoneImageView setFrame:iPhoneFrame];
    }];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _permissionDescription.alpha = 1.0f;
        _permissionButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [_permissionButton setUserInteractionEnabled:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToNextState {
    currentState = currentState + 1;
    
    switch (currentState) {
        case 0:
            //[self viewDidLoad];
            break;
        case 1:
            //pierwszy screen - pytanie o kamerę i mikrofon
            [self firstStateAskCameraAndMicrophone];
            break;
        case 2:
            [self askPermissioniPhoneCenteredWithTextDirectionLeft:NO];
            [self gotCameraPermission];
            break;
        case 3:
            //drugi screen - dostęp do zdjęć
            [self secondStateAskLibrary];
            break;
        case 4:
            [self askPermissioniPhoneCenteredWithTextDirectionLeft:YES];
            [self gotLibraryPermission];
            break;
        case 5:
            //trzeci screen - GPS
            [self thirdStateAskGPS];
            break;
        case 6:
            [self askPermissioniPhoneCenteredWithTextDirectionLeft:YES];
            [self gotGPSPermission];
        case 7:
            [self finishTutorial];
            break;
        case 8:
            [_delegate didEndTutorialWithRegistration:YES];
            break;
        default:
            break;
    }
}

- (void)recoverCurrentState {
    //currentState = currentState - 1;
    //[self goToNextState];
}

- (void)firstStateAskCameraAndMicrophone {
    
    //przesunięcie iPhone'a na lewo
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_iPhoneImageView setFrame:CGRectMake(-_iPhoneImageView.frame.size.width + 100, _iPhoneImageView.frame.origin.y, _iPhoneImageView.frame.size.width, _iPhoneImageView.frame.size.height)];
    } completion:^(BOOL finished) {
        [_iPhoneImageView setFrame:CGRectMake(-_iPhoneImageView.frame.size.width + 100, _iPhoneImageView.frame.origin.y, _iPhoneImageView.frame.size.width, _iPhoneImageView.frame.size.height)];
        
        [_permissionDescription setText:NSLocalizedString(@"Tutorial2", nil)];
        [_permissionDescription setFrame:CGRectMake(self.view.frame.size.width, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
        [UIView animateWithDuration:0.3 animations:^{
            [_permissionDescription setFrame:CGRectMake(110.0, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
            [_permissionDescription setAlpha:1.0];
        } completion:^(BOOL finished) {
            [_permissionDescription setFrame:CGRectMake(110.0, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
            [_permissionDescription setAlpha:1.0];
        }];
    }];
    
    //schowanie opisu
    [UIView animateWithDuration:0.5 animations:^{
        [_permissionDescription setCenter:CGPointMake(-(_permissionDescription.frame.size.width/2.0), _permissionDescription.center.y)];
        [_permissionDescription setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [_permissionTitle setText:NSLocalizedString(@"Tutorial2Title", nil)];
            [_permissionButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            [_permissionTitle setText:NSLocalizedString(@"Tutorial2Title", nil)];
            [_permissionButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
        }];
    }];
}

- (void)secondStateAskLibrary {
    NSLog(@"secondStateAskLibrary");
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(secondStateAskLibrary) object:nil];
    
    if (runningAnimation == YES) {
        [self performSelector:@selector(secondStateAskLibrary) withObject:nil afterDelay:1.0];
    } else {
        
        NSLog(@"iphone nie animuje sie");
        [_permissionTitle setText:NSLocalizedString(@"Tutorial3Title", nil)];
        [_permissionDescription setText:NSLocalizedString(@"Tutorial3", nil)];
        [_permissionButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
        
        [_permissionTitle setAlpha:0.0];
        [_permissionDescription setAlpha:0.0];
        [_permissionButton setAlpha:0.0];
        
        [_permissionDescription setFrame:CGRectMake(-_permissionDescription.frame.size.width, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
        
        [UIView animateWithDuration:0.5 animations:^{
            [_permissionTitle setFrame:CGRectMake(_permissionTitle.frame.origin.x, 0, _permissionTitle.frame.size.width, _permissionTitle.frame.size.height)];
            [_permissionTitle setAlpha:1.0];
            
            [_permissionButton setFrame:CGRectMake(self.view.frame.size.width * 0.125, _permissionTitle.frame.size.height + _iPhoneImageView.frame.size.height + 15.0, self.view.frame.size.width * 0.75, self.view.frame.size.height - (_permissionTitle.frame.size.height + _iPhoneImageView.frame.size.height + 15.0) - 15.0)];
            [_permissionButton setAlpha:1.0];
            
            [_iPhoneImageView setFrame:CGRectMake(self.view.frame.size.width - 100.0, _iPhoneImageView.frame.origin.y, _iPhoneImageView.frame.size.width, _iPhoneImageView.frame.size.height)];
            
            [_permissionDescription setFrame:CGRectMake(10.0, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
            [_permissionDescription setAlpha:1.0];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)thirdStateAskGPS {
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(thirdStateAskGPS) object:nil];
    
    if (runningAnimation == YES) {
        [self performSelector:@selector(thirdStateAskGPS) withObject:nil afterDelay:1.0];
    } else {
        
        NSLog(@"iphone nie animuje sie");
        [_permissionTitle setText:NSLocalizedString(@"Tutorial4Title", nil)];
        [_permissionDescription setText:NSLocalizedString(@"Tutorial4", nil)];
        [_permissionButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
        
        [_permissionTitle setAlpha:0.0];
        [_permissionDescription setAlpha:0.0];
        [_permissionButton setAlpha:0.0];
        
        [_permissionDescription setFrame:CGRectMake(-_permissionDescription.frame.size.width, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
        
        [UIView animateWithDuration:0.5 animations:^{
            [_permissionTitle setFrame:CGRectMake(_permissionTitle.frame.origin.x, 0, _permissionTitle.frame.size.width, _permissionTitle.frame.size.height)];
            [_permissionTitle setAlpha:1.0];
            
            [_permissionButton setFrame:CGRectMake(self.view.frame.size.width * 0.125, _permissionTitle.frame.size.height + _iPhoneImageView.frame.size.height + 15.0, self.view.frame.size.width * 0.75, self.view.frame.size.height - (_permissionTitle.frame.size.height + _iPhoneImageView.frame.size.height + 15.0) - 15.0)];
            [_permissionButton setAlpha:1.0];
            
            [_iPhoneImageView setFrame:CGRectMake(self.view.frame.size.width - 100.0, _iPhoneImageView.frame.origin.y, _iPhoneImageView.frame.size.width, _iPhoneImageView.frame.size.height)];
            
            [_permissionDescription setFrame:CGRectMake(10.0, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
            [_permissionDescription setAlpha:1.0];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)finishTutorial {
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishTutorial) object:nil];
    
    if (runningAnimation == YES) {
        [self performSelector:@selector(finishTutorial) withObject:nil afterDelay:1.0];
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            [_permissionDescription setFrame:CGRectMake(self.view.frame.size.width, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
            [_permissionDescription setAlpha:0.0];
            
            [_permissionTitle setFrame:CGRectMake(_permissionTitle.frame.origin.x, -_permissionTitle.frame.size.height, _permissionTitle.frame.size.width, _permissionTitle.frame.size.height)];
            [_permissionButton setFrame:CGRectMake(_permissionButton.frame.origin.x, self.view.frame.size.height, _permissionButton.frame.size.width, _permissionButton.frame.size.height)];
            
            [_permissionDescription setAlpha:0.0];
            [_permissionButton setAlpha:0.0];
            
            [_iPhoneImageView setAlpha:1.0];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [_iPhoneImageView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
            } completion:^(BOOL finished) {
                
                [_iPhoneImageView setContentMode:UIViewContentModeScaleToFill];
                
                [self.view bringSubviewToFront:_permissionDescription];
                [self.view bringSubviewToFront:_permissionButton];
                
                [_permissionDescription setFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 200)];
                
                float endScale = 2.0;
                CGAffineTransform t = CGAffineTransformMakeScale(endScale, endScale);
                
                [UIView animateWithDuration:0.5 animations:^{
                    _iPhoneImageView.transform = t;
                } completion:^(BOOL finished) {
                    
                    [_permissionDescription setAlpha:0.0];
                    [_permissionButton setAlpha:0.0];
                    
                    [_permissionDescription setText:NSLocalizedString(@"Tutorial5", nil)];
                    
                    UIButton *noLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [noLoginButton setBackgroundColor:[UIColor clearColor]];
                    [noLoginButton.titleLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:15.0]];
                    [noLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [noLoginButton setTitle:NSLocalizedString(@"Not now", nil) forState:UIControlStateNormal];
                    
                    [noLoginButton setFrame:CGRectMake(0.0, self.view.frame.size.height - 25, self.view.frame.size.width * 0.75, 20)];
                    [noLoginButton setCenter:CGPointMake(self.view.center.x, noLoginButton.center.y)];
                    [noLoginButton setUserInteractionEnabled:NO];
                    [noLoginButton addTarget:self action:@selector(noLogin) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:noLoginButton];
                    noLoginButton.alpha = 0.0;
                    
                    [_permissionDescription setFrame:CGRectMake(self.view.frame.size.width, _permissionDescription.frame.origin.y, self.view.frame.size.width * 0.75, _permissionDescription.frame.size.height)];
                    [_permissionButton setFrame:CGRectMake(_permissionButton.frame.origin.x, self.view.frame.size.height, _permissionButton.frame.size.width, _permissionButton.frame.size.height)];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        [_permissionDescription setAlpha:1.0];
                        [_permissionButton setAlpha:1.0];
                        
                        [_permissionDescription setFrame:CGRectMake(self.view.frame.size.width * 0.125, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
                        
                        [_permissionButton setFrame:CGRectMake(_permissionButton.frame.origin.x, self.view.frame.size.height - _permissionButton.frame.size.height - noLoginButton.frame.size.height - 15, _permissionButton.frame.size.width, _permissionButton.frame.size.height)];
                        
                    } completion:^(BOOL finished) {
                        [noLoginButton setUserInteractionEnabled:YES];
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            [noLoginButton setAlpha:1.0];
                        }];
                    }];
                    
                }];
                
                
                
            }];
        }];
    }
}

- (void)noLogin {
    [_delegate didEndTutorialWithRegistration:NO];
}

- (void)askPermissioniPhoneCenteredWithTextDirectionLeft:(BOOL)shouldGoLeft {
    
    NSLog(@"askPermissioniPhoneCentered");
    
    runningAnimation = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [_permissionDescription setFrame:CGRectMake(shouldGoLeft ? -_permissionDescription.frame.size.width : self.view.frame.size.width, _permissionDescription.frame.origin.y, _permissionDescription.frame.size.width, _permissionDescription.frame.size.height)];
        [_permissionDescription setAlpha:0.0];
        
        [_permissionTitle setFrame:CGRectMake(_permissionTitle.frame.origin.x, -_permissionTitle.frame.size.height, _permissionTitle.frame.size.width, _permissionTitle.frame.size.height)];
        [_permissionButton setFrame:CGRectMake(_permissionButton.frame.origin.x, self.view.frame.size.height, _permissionButton.frame.size.width, _permissionButton.frame.size.height)];
        
        [_permissionTitle setAlpha:0.0];
        [_permissionButton setAlpha:0.0];
        
        [_iPhoneImageView setAlpha:1.0];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            [_iPhoneImageView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
        } completion:^(BOOL finished) {
            NSLog(@"ask permission finished");
            runningAnimation = NO;
        }];
    }];

}

- (void)noPermissionScreen {
    [self.view setBackgroundColor:[UIColor redColor]];
    [UIView animateWithDuration:0.3 animations:^{
        [_permissionDescription setAlpha:0.0];
        [_permissionButton setAlpha:0.0];
        [_iPhoneImageView setAlpha:0.0];
        [_backgroundImageView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_permissionTitle setText:NSLocalizedString(@"TutorialErrorTitle", nil)];
        [_permissionDescription setText:NSLocalizedString(@"TutorialErrorDescription", nil)];
        [_permissionTitle setFrame:CGRectMake(_permissionTitle.frame.origin.x, 0.0, _permissionTitle.frame.size.width, _permissionTitle.frame.size.height)];
        [_permissionDescription setFrame:CGRectMake(10.0, _permissionDescription.frame.origin.y, self.view.frame.size.width-20.0, _permissionDescription.frame.size.height)];
        [UIView animateWithDuration:0.3 animations:^{
            [_permissionDescription setAlpha:1.0];
            [_permissionTitle setAlpha:1.0];
        }];
    }];
}

#pragma mark- Helpers
- (BOOL)gotCameraPermission {
    
    NSLog(@"gotCameraPermission");
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotCameraPermission) object:nil];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized) {
        //authorized
        NSLog(@"Mamy kamerę!");
        [self gotMicrophonePermission];
        return YES;
    } else if (status == AVAuthorizationStatusDenied) {
        //denied
        [self noPermissionScreen];
        return NO;
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            NSLog(@"Again and again: granted: %@", granted ? @"TAK" : @"NIE");
        }];
        
        [self performSelector:@selector(gotCameraPermission) withObject:nil afterDelay:0.5];
    }
    
    return NO;
}

- (BOOL)gotMicrophonePermission {
    
    NSLog(@"gotMicrofonePermission");
    
    __block BOOL gotPermission = NO;
    
    
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                gotPermission = YES;
                [self goToNextState];
            } else {
                gotPermission = NO;
                [self noPermissionScreen];
            }
        }];
    }

    
    return gotPermission;
}

- (BOOL)gotLibraryPermission {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotLibraryPermission) object:nil];
    
    if (status == ALAuthorizationStatusAuthorized) {
        [self goToNextState];
        return YES;
    } else if (status == ALAuthorizationStatusDenied) {
        [self noPermissionScreen];
        return NO;
    } else if (status == ALAuthorizationStatusNotDetermined) {
        
        ALAssetsLibrary *aLib = [[ALAssetsLibrary alloc]init];
        
        [aLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:nil failureBlock:nil];
        
        aLib = nil;
        
        [self performSelector:@selector(gotLibraryPermission) withObject:nil afterDelay:0.5];
    }
    
    return NO;
}

- (BOOL)gotGPSPermission {
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotGPSPermission) object:nil];
    
    [GPSUtilities sharedInstance];
    BOOL permission = [[GPSUtilities sharedInstance] askPermission];
    
    if (permission && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self goToNextState];
        return YES;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self performSelector:@selector(gotGPSPermission) withObject:nil afterDelay:0.5];
        return NO;
    } else {
        [self noPermissionScreen];
        return NO;
    }
}

#pragma mark- UINavigationController Delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}

@end
