//
//  ViewController.m
//  Wideo Rejestrator
//
//  Created by Michał Czwarnowski on 06.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //TODO: Create tutorial here
    [self initializeCamera];
    
    [self initializeInterface];
}
/**
 *  @Author Michał Czwarnowski
 *
 *  Initializes main camera picker and adds its view to main view as subview
 */
- (void)initializeCamera {
    if (!self.pickerController) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ||
                [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                self.pickerController = [[UIImagePickerController alloc] init];
                [self.pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                //[self.pickerController setCameraCaptureMode:UIImagePickerControllerCameraCaptureModeVideo];
                self.pickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
                [self.pickerController setAllowsEditing:NO];
                
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                    [self.pickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
                } else {
                    [self.pickerController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
                }
                
                [self.pickerController setShowsCameraControls:NO];
                [self.pickerController setDelegate:self];
                self.pickerController.cameraViewTransform = CGAffineTransformIdentity;
                self.pickerController.videoQuality = UIImagePickerControllerQualityType640x480;
                
                CGRect originalCameraFrame = self.pickerController.view.frame;
                originalCameraFrame.origin.x = (self.view.frame.size.width - originalCameraFrame.size.width)/2;
                originalCameraFrame.origin.y = (self.view.frame.size.height - originalCameraFrame.size.height)/2;
                self.pickerController.view.frame = originalCameraFrame;
                [self.pickerController setModalPresentationStyle:UIModalPresentationFullScreen];
                
                if (![self.pickerController.view isDescendantOfView:self.view]) {
                    [self.view addSubview:self.pickerController.view];
                }

            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                      message:NSLocalizedString(@"Camera is not available", @"Camera is not available")
                                                                     delegate:nil
                                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
            }
            
        } else {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                  message:NSLocalizedString(@"Device has no camera", @"Device has no camera")
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
        }
    }
    
    
}

/**
 *  @Author Michał Czwarnowski
 *
 *  Initializes all subviews
 */
- (void)initializeInterface {
    if (!self.upperBackgroundView) {
        self.upperBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [self.upperBackgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:59.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [self.upperBackgroundView setAlpha:0.9];
    }
    
    if (![self.upperBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.upperBackgroundView];
    }
    
    if (!self.lowerBackgroundView) {
        self.lowerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-95, self.view.frame.size.width, 95)];
        [self.lowerBackgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:59.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [self.lowerBackgroundView setAlpha:0.9];
    }
    
    if (![self.lowerBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.lowerBackgroundView];
    }
    
    if (!self.cameraRecordingButton) {
        self.cameraRecordingButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-75)/2, self.view.frame.size.height-10-75, 75, 75)];
        [self.cameraRecordingButton setUserInteractionEnabled:YES];
        [self.cameraRecordingButton setBackgroundColor:[UIColor redColor]];
        [self.cameraRecordingButton.layer setCornerRadius:self.cameraRecordingButton.frame.size.width/2.0];
    }
    
    if (![self.cameraRecordingButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.cameraRecordingButton];
    }
    
    [self.cameraRecordingButton removeTarget:self action:@selector(toggleVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraRecordingButton addTarget:self action:@selector(toggleVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *whiteLine1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white line" ofType:@"png"]]];
    [whiteLine1 setFrame:CGRectMake(10, self.view.frame.size.height-46-2, whiteLine1.frame.size.width/2, whiteLine1.frame.size.height/2)];
    [self.view addSubview:whiteLine1];
    
    UIImageView *whiteLine2 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white line" ofType:@"png"]]];
    [whiteLine2 setFrame:CGRectMake(self.view.frame.size.width-10-whiteLine2.frame.size.width/2, self.view.frame.size.height-46-2, whiteLine2.frame.size.width/2, whiteLine2.frame.size.height/2)];
    [self.view addSubview:whiteLine2];
}

/**
 *  @Author Michał Czwarnowski
 *
 *  Starts or ends recording depenging on camera state
 */
- (void)toggleVideoRecording {
    if (!_isRecording) {
        _isRecording = YES;
        [self startRecording];
    } else {
        _isRecording = NO;
        [self stopRecording];
    }
}

/**
 *  @Author Michał Czwarnowski
 *
 *  Blinks recording button when isRecording flag is set to YES
 */
/*- (void)flashCameraButton {
    if (_isRecording) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.cameraRecordingButton setBackgroundColor:[UIColor whiteColor]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    [self.cameraRecordingButton setBackgroundColor:[UIColor redColor]];
                } completion:^(BOOL finished) {
                    [self flashCameraButton];
                }];
            }];
        });
    }
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @Author Michał Czwarnowski
 *
 *  Starts recording showing small rotating white dot at button
 */
- (void)startRecording {
    
//    [self flashCameraButton];
    
    if (!self.smallDotImageView) {
        self.smallDotImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"smallDotImage" ofType:@"png"]]];
    }
    
    [self.smallDotImageView setFrame:CGRectMake(5, 5, self.smallDotImageView.frame.size.width/2, self.smallDotImageView.frame.size.height/2)];
    
    if (![self.smallDotImageView isDescendantOfView:self.cameraRecordingButton]) {
        [self.cameraRecordingButton addSubview:self.smallDotImageView];
    }
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.smallDotImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    rotationAnimation = nil;
    
    [self.pickerController startVideoCapture];
    
}

- (void)stopRecording {
    
    [self.smallDotImageView.layer removeAllAnimations];
    [self.smallDotImageView removeFromSuperview];
    
    [self.pickerController stopVideoCapture];
}

#pragma mark- UIImagePicker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    NSString *pathToVideo = [videoURL path];
    BOOL okToSaveVideo = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToVideo);
    if (okToSaveVideo) {
        UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    } else {
        [self video:pathToVideo didFinishSavingWithError:nil contextInfo:NULL];
    }
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                              message:NSLocalizedString(@"Video can not be saved.", @"Video can not be saved.")
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        NSLog(@"Error: %@", [error localizedDescription]);
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

@end
