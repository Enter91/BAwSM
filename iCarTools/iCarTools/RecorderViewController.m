//
//  RecorderViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 27.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "RecorderViewController.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface RecorderViewController () {
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureVideoDataOutput *output;
    AVCaptureVideoPreviewLayer *mCameraLayer;
    UIView *mCameraView;
    AVCaptureMovieFileOutput *movieFile;
}

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    [self.gpsUtilities startGPS];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self updateDataSourceInLeftRevealViewController];

}

- (void)updateDataSourceInLeftRevealViewController {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[@"Settings", @"Recordings"]];
    }
}

- (void)dealloc {
    [self.gpsUtilities stopGPS];
    self.gpsUtilities.delegate = nil;
    self.gpsUtilities = nil;
}


- (void)viewDidAppear:(BOOL)animated {
    
    [self initializeCamera];
    
    [self initializeInterface];
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
    
    if (!self.menuButton) {
        self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.menuButton setImage:[UIImage imageNamed:@"menu-128"] forState:UIControlStateNormal];  }
    
    if (![self.menuButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.menuButton];
    }

    if (!self.exitButton) {
        self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.upperBackgroundView.frame.size.width-34, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.exitButton setImage:[UIImage imageNamed:@"exit-50"] forState:UIControlStateNormal];
    }
    
    if (![self.exitButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.exitButton];
    }
    
    [self.exitButton removeTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.cameraRecordingButton) {
        self.cameraRecordingButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-75)/2, self.view.frame.size.height-10-75, 75, 75)];
        [self.cameraRecordingButton setBackgroundColor:[UIColor clearColor]];
        [self.cameraRecordingButton setImage:[UIImage imageNamed:@"record_button"] forState:UIControlStateNormal];
        [self.cameraRecordingButton setUserInteractionEnabled:YES];
        
    }
    
    if (![self.cameraRecordingButton isDescendantOfView:self.view]) {
        [self.view addSubview:self.cameraRecordingButton];
    }
    
    [self.cameraRecordingButton removeTarget:self action:@selector(toggleVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraRecordingButton addTarget:self action:@selector(toggleVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    
    if (!_whiteLine1) {
        _whiteLine1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white line" ofType:@"png"]]];
        [_whiteLine1 setFrame:CGRectMake(10, self.view.frame.size.height-46-2, (self.view.frame.size.width-75.0)/2-20, _whiteLine1.frame.size.height/2)];
        [self.view addSubview:_whiteLine1];
    }
    
    if (!_whiteLine2) {
        _whiteLine2 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white line" ofType:@"png"]]];
        [_whiteLine2 setFrame:CGRectMake(self.view.frame.size.width-((self.view.frame.size.width-75.0)/2-10), self.view.frame.size.height-46-2, (self.view.frame.size.width-75.0)/2-20, _whiteLine2.frame.size.height/2)];
        [self.view addSubview:_whiteLine2];
    }
    
    if (!self.speedLabel) {
        self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-47-48, 73, 48)];
        [self.speedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:40]];
        [self.speedLabel setTextAlignment:NSTextAlignmentRight];
        [self.speedLabel setTextColor:[UIColor whiteColor]];
        [self.speedLabel setText:@"0"];
        [self.view addSubview:self.speedLabel];
    }
    
    if (!self.speedUnitsLabel) {
        self.speedUnitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.view.frame.size.height-68-27, 25, 27)];
        [self.speedUnitsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
        [self.speedUnitsLabel setTextAlignment:NSTextAlignmentCenter];
        [self.speedUnitsLabel setTextColor:[UIColor whiteColor]];
        [self.speedUnitsLabel setText:@"km/h"];
        [self.view addSubview:self.speedUnitsLabel];
    }
    
    if (!self.speedNotificationButton) {
        self.speedNotificationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+4, 79, 37)];
        [self.speedNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.speedNotificationButton.center.y)];
        [self.speedNotificationButton setImage:[UIImage imageNamed:@"suszarka"] forState:UIControlStateNormal];
        [self.view addSubview:self.speedNotificationButton];
    }
    
    if (!self.crashNotificationButton) {
        self.crashNotificationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.whiteLine2.frame.origin.y+6, 79, 37)];
        [self.crashNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.crashNotificationButton.center.y)];
        [self.crashNotificationButton setImage:[UIImage imageNamed:@"wypadek"] forState:UIControlStateNormal];
        [self.view addSubview:self.crashNotificationButton];
    }
    
    if (!self.gpsStatusImageView) {
        self.gpsStatusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps_searching-256"]];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y+6, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.gpsStatusImageView.center.y)];
        [self.view addSubview:self.gpsStatusImageView];
    }
    
    [self setFramesForInterface:self.interfaceOrientation];
}

- (void)setFramesForInterface:(UIInterfaceOrientation)toInterfaceOrientation {
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationPortrait:
            [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
             [self setFramesForPortrait];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self setFramesForLandscapeLeft];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self setFramesForLandscapeLeft];
            break;
            
        default:
            break;
    }
}

- (void)setFramesForPortrait {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.upperBackgroundView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [self.lowerBackgroundView setFrame:CGRectMake(0, self.view.frame.size.height-95, self.view.frame.size.width, 95)];
        [self.menuButton setFrame:CGRectMake(10, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.exitButton setFrame:CGRectMake(self.upperBackgroundView.frame.size.width-34, 5, 30, self.upperBackgroundView.frame.size.height-10)];
        [self.cameraRecordingButton setFrame:CGRectMake((self.view.frame.size.width-75)/2, self.view.frame.size.height-10-75, 75, 75)];
        [self.cameraRecordingButton setCenter:self.lowerBackgroundView.center];
        [self.whiteLine1 setFrame:CGRectMake(10, self.lowerBackgroundView.center.y-1, (self.view.frame.size.width-75.0)/2-20, 2)];
        [self.whiteLine2 setFrame:CGRectMake(self.cameraRecordingButton.frame.origin.x + self.cameraRecordingButton.frame.size.width + 10, self.lowerBackgroundView.center.y-1, (self.view.frame.size.width-75.0)/2-20, 2)];
        [self.speedUnitsLabel setFrame:CGRectMake(self.cameraRecordingButton.center.x - 75/2.0 - 35, self.view.frame.size.height-68-27, 25, 27)];
        [self.speedLabel setFrame:CGRectMake(10, self.view.frame.size.height-47-48, self.speedUnitsLabel.frame.origin.x - 10, 48)];
        [self.speedNotificationButton setFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+4, 79, 37)];
        [self.speedNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.speedNotificationButton.center.y)];
        [self.crashNotificationButton setFrame:CGRectMake(0, self.whiteLine2.frame.origin.y+6, 79, 37)];
        [self.crashNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.crashNotificationButton.center.y)];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y+6, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.gpsStatusImageView.center.y)];
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.upperBackgroundView setFrame:CGRectMake(0, 0, 44, self.view.frame.size.height)];
        [self.lowerBackgroundView setFrame:CGRectMake(self.view.frame.size.width-95, 0, 95, self.view.frame.size.height)];
        [self.menuButton setFrame:CGRectMake(5, 10, 34, 34)];
        [self.exitButton setFrame:CGRectMake(5, self.view.frame.size.height-55, 34, 34)];        [self.cameraRecordingButton setFrame:CGRectMake(self.view.frame.size.width-10-75, (self.view.frame.size.height-75)/2, 75, 75)];
        [self.cameraRecordingButton setCenter:self.lowerBackgroundView.center];
        [self.whiteLine1 setFrame:CGRectMake(self.view.frame.size.width - 90, (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.whiteLine2 setFrame:CGRectMake(self.view.frame.size.width - 90, self.view.frame.size.height - (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.speedLabel setFrame:CGRectMake(self.view.frame.size.width - 85, 0, 60, self.whiteLine1.frame.origin.y)];
        [self.speedUnitsLabel setFrame:CGRectMake(self.view.frame.size.width - 25, 0, 25, 27)];
        
        [self.speedNotificationButton setFrame:CGRectMake(0, 0, 79, 37)];
        [self.speedNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.cameraRecordingButton.frame.origin.y + self.cameraRecordingButton.frame.size.height + (self.whiteLine2.frame.origin.y - self.cameraRecordingButton.frame.origin.y - self.cameraRecordingButton.frame.size.height)/2.0)];
        
        [self.crashNotificationButton setFrame:CGRectMake(0, 0, 79, 37)];
        [self.crashNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.whiteLine2.frame.origin.y + self.whiteLine2.frame.size.height + (self.view.frame.size.height - (self.whiteLine2.frame.origin.y+self.whiteLine2.frame.size.height))/2.0)];
        
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height + (self.cameraRecordingButton.frame.origin.y - (self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height))/2.0, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height + (self.cameraRecordingButton.frame.origin.y - (self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height))/2.0)];
    });
}

- (void)setFramesForLandscapeRight {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.upperBackgroundView setFrame:CGRectMake(self.view.frame.size.width-44, 0, 44, self.view.frame.size.height)];
        [self.lowerBackgroundView setFrame:CGRectMake(0, 0, 95, self.view.frame.size.height)];
        [self.menuButton setFrame:CGRectMake(0, 10, 44, 44)];
        [self.exitButton setFrame:CGRectMake(self.upperBackgroundView.center.x, 0, 44, 44)];
        [self.cameraRecordingButton setFrame:CGRectMake(10, (self.view.frame.size.height-75)/2, 75, 75)];
        [self.cameraRecordingButton setCenter:self.lowerBackgroundView.center];
        [self.whiteLine1 setFrame:CGRectMake(5, (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.whiteLine2 setFrame:CGRectMake(5, self.view.frame.size.height - (self.view.frame.size.height-75)/4.0 - 1, 85, 2)];
        [self.speedLabel setFrame:CGRectMake(10, 0, 60, self.whiteLine1.frame.origin.y)];
        [self.speedUnitsLabel setFrame:CGRectMake(70, 0, 25, 27)];
        
        [self.speedNotificationButton setFrame:CGRectMake(0, 0, 79, 37)];
        [self.speedNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.cameraRecordingButton.frame.origin.y + self.cameraRecordingButton.frame.size.height + (self.whiteLine2.frame.origin.y - self.cameraRecordingButton.frame.origin.y - self.cameraRecordingButton.frame.size.height)/2.0)];
        
        [self.crashNotificationButton setFrame:CGRectMake(0, 0, 79, 37)];
        [self.crashNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.whiteLine2.frame.origin.y + self.whiteLine2.frame.size.height + (self.view.frame.size.height - (self.whiteLine2.frame.origin.y+self.whiteLine2.frame.size.height))/2.0)];
        
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, 0.0, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height + (self.cameraRecordingButton.frame.origin.y - (self.whiteLine1.frame.origin.y + self.whiteLine1.frame.size.height))/2.0)];
    });
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
    
    if ([self.smallDotImageView isDescendantOfView:self.cameraRecordingButton]) {
        [self.smallDotImageView removeFromSuperview];
    }
    
    if (self.smallDotImageView) {
        self.smallDotImageView = nil;
    }
    
    self.smallDotImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"smallDotImage" ofType:@"png"]]];
    
    [self.smallDotImageView setFrame:CGRectMake(5, 5, self.smallDotImageView.frame.size.width/2, self.smallDotImageView.frame.size.height/2)];
    
    self.smallDotImageView.alpha = 0.0f;
    
    [self.cameraRecordingButton addSubview:self.smallDotImageView];
    
    [self.smallDotImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.smallDotImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.smallDotImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.smallDotImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.cameraRecordingButton addConstraint:[NSLayoutConstraint constraintWithItem:self.smallDotImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.cameraRecordingButton attribute:NSLayoutAttributeWidth multiplier:65.0/75.0 constant:0.0]];
    [self.cameraRecordingButton addConstraint:[NSLayoutConstraint constraintWithItem:self.smallDotImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cameraRecordingButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.cameraRecordingButton addConstraint:[NSLayoutConstraint constraintWithItem:self.smallDotImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cameraRecordingButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.smallDotImageView.alpha = 1.0f;
    }];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.smallDotImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    rotationAnimation = nil;
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            
        }
    }
    //Start recording
    [[mCameraLayer connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
    [movieFile startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        
}

- (void)stopRecording {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.smallDotImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.smallDotImageView removeFromSuperview];
        [self.smallDotImageView.layer removeAllAnimations];
        self.smallDotImageView.alpha = 1.0f;
    }];
    
    [movieFile stopRecording];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     
                 }
             }];
        }
    }
}

- (void) initializeCamera {
    //Capture Session
    
    if (!mCameraView) {
        mCameraView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    if (![mCameraView isDescendantOfView:self.view]) {
        [self.view addSubview:mCameraView];
    }
    
    if (session) {
        session = nil;
    }
    
    if (device) {
        device = nil;
    }
    
    if (input) {
        input = nil;
    }
    
    session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPreset1280x720;

    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device)
    {
        NSError *error;
        input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!error)
        {
            if ([session canAddInput:input]) {
                [session addInput:input];
            } else {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                      message:NSLocalizedString(@"Couldn\'t add video input", @"Couldn\'t add video input")
                                                                     delegate:nil
                                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                            otherButtonTitles: nil];
                [myAlertView show];
                myAlertView = nil;
                input = nil;
                device = nil;
                session = nil;
                return;
            }
            
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                  message:NSLocalizedString(@"Couldn\'t create video input", @"Couldn\'t create video input")
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                        otherButtonTitles: nil];
            [myAlertView show];
            myAlertView = nil;
            input = nil;
            device = nil;
            session = nil;
            return;
        }
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                              message:NSLocalizedString(@"Couldn\'t create video capture device", @"Couldn\'t create video capture device")
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                    otherButtonTitles: nil];
        [myAlertView show];
        myAlertView = nil;
        input = nil;
        device = nil;
        session = nil;
        return;
    }
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (audioInput)
    {
        [session addInput:audioInput];
    }
    
    movieFile = [[AVCaptureMovieFileOutput alloc] init];
    Float64 TotalSeconds = 3600;
    int32_t preferredTimeScale = 24;
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    movieFile.maxRecordedDuration = maxDuration;
    
    movieFile.minFreeDiskSpaceLimit = 1024 * 1024 * 100;
    if ([session canAddOutput:movieFile])
        [session addOutput:movieFile];
    
    if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    else if ([session canSetSessionPreset:AVCaptureSessionPreset640x480])
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetMedium];
    
    [self startCamera];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    mCameraView.alpha = 0.0;
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    mCameraView.alpha = 0.0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([session isRunning]) {
            mCameraView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
            mCameraView.bounds = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
            [self startCamera];
            mCameraView.alpha = 1.0;
        } else {
            [self initializeCamera];
        }
    });
}

- (void)startCamera
{
    [session startRunning];
    
    if (mCameraLayer) {
        [mCameraLayer removeFromSuperlayer];
        mCameraLayer = nil;
    }
    
    mCameraLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    [self updateCameraLayer];
    [mCameraView.layer addSublayer:mCameraLayer];
}

- (void)stopCamera
{
    [session stopRunning];
    [mCameraLayer removeFromSuperlayer];
    mCameraLayer = nil;
    session = nil;
}

- (void)toggleCamera
{
    session.isRunning ? [self stopCamera] : [self startCamera];
}

- (void)updateCameraLayer
{
    mCameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    mCameraLayer.frame = mCameraView.bounds;
    float x = mCameraView.frame.origin.x;
    float y = mCameraView.frame.origin.y;
    float w = mCameraView.frame.size.width;
    float h = mCameraView.frame.size.height;
    CATransform3D transform = CATransform3DIdentity;
    if (UIDeviceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation]) {
        mCameraLayer.frame = CGRectMake(x, y, h, w);
        transform = CATransform3DTranslate(transform, (w - h) / 2, (h - w) / 2, 0);
        transform = CATransform3DRotate(transform, -M_PI/2, 0, 0, 1);
    } else if (UIDeviceOrientationLandscapeRight == [[UIDevice currentDevice] orientation]) {
        mCameraLayer.frame = CGRectMake(x, y, h, w);
        transform = CATransform3DTranslate(transform, (w - h) / 2, (h - w) / 2, 0);
        transform = CATransform3DRotate(transform, M_PI/2, 0, 0, 1);
    } else if (UIDeviceOrientationPortraitUpsideDown == [[UIDevice currentDevice] orientation]) {
        mCameraLayer.frame = mCameraView.bounds;
        transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    } else {
        mCameraLayer.frame = mCameraView.bounds;
    }
    mCameraLayer.transform  = transform;
}


#pragma mark- GPSUtilities Delegates
- (void)locationUpdate:(CLLocation *)location {
    float speedInMetersPerSecond = location.speed;
    int speedInKilometersPerHour = speedInMetersPerSecond * 3600 / 1000;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (speedInKilometersPerHour >= 0) {
            [self.speedLabel setText:[NSString stringWithFormat:@"%d", speedInKilometersPerHour]];
        } else {
            [self.speedLabel setText:@"0"];
        }
    });
    
    NSLog(@"New Location: %@", location);
}

- (void)locationError:(NSError *)error {
    NSLog(@"Location error: %@", [error localizedDescription]);
}

#pragma mark- UINavigationController Delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)exit {
    [self.gpsUtilities stopGPS];
    [self.revealViewController pushFrontViewController:_parentView animated:YES];
    _parentView = nil;
    //    [self.delegate recorderViewWantsDismiss];
}

#pragma mark- SettingsViewController Delegates
- (void)clickedOption:(int)number {
    switch (number) {
        case <#constant#>:
            <#statements#>
            break;
            
        default:
            break;
    }
}

@end