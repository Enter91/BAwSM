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
    NSString *startRecordingDate;
    
    int speedCalculator;
    NSMutableArray *supportedVideoQuality;
    NSMutableArray *supportedVideoQualityTranslatedNames;
    BOOL didChangeCameraSettings;
    
    UILabel *titleLabel;
    UILabel *gpsStatusLabel;
}

@property (strong, nonatomic) NSBag *speedCameraBag;
@property (strong, nonatomic) NSBag *crashAccidentBag;
@property (strong, nonatomic) NSMutableArray *speedCameraSortedArray;
@property (strong, nonatomic) NSMutableArray *crashAccidentSortedArray;

@property CLLocationDegrees minDBLat, minDBLong, maxDBLat, maxDBLong;
@property BOOL shouldForceStopNotification;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"enableAudio"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"enableAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"speed unit"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"km/h" forKey:@"speed unit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        speedCalculator = 1;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"video quality"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"video quality"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _shouldForceStopNotification = NO;
    
    supportedVideoQuality = [[NSMutableArray alloc] init];
    supportedVideoQualityTranslatedNames = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/iCarTools"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    [self orientationUnlock];
    
    _wantsCustomAnimation = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _pointsOnTheRouteArray = [[NSMutableArray alloc] init];
    
    self.gpsUtilities = [GPSUtilities sharedInstance];
    self.gpsUtilities.delegate = self;
    //[self.gpsUtilities setIsDistanceFilterEnable:YES];
    [self.gpsUtilities setAccuracy:kCLLocationAccuracyBestForNavigation];
    [self.gpsUtilities startGPS];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self updateDataSourceInLeftRevealViewController];

    [((SettingsViewController *)self.revealViewController.rearViewController) setDelegate:self];
    
    [[AmazingJSON sharedInstance] setDelegate:self];
    
    self.revealViewController.panGestureRecognizer.enabled = YES;
    self.revealViewController.tapGestureRecognizer.enabled = YES;
}

- (void)dealloc {
    [self exit];
}

- (void)viewWillAppear:(BOOL)animated {
    
    _minDBLat = HUGE_VALF;
    _minDBLong = HUGE_VALF;
    _maxDBLat = -HUGE_VALF;
    _maxDBLong = -HUGE_VALF;
    
    _shouldForceStopNotification = NO;
    
    self.revealViewController.panGestureRecognizer.enabled = YES;
    self.revealViewController.tapGestureRecognizer.enabled = YES;
    
    [self initializeInterface];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyUserAboutNearestAccident) object:nil];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDatabaseOfAccidents) object:nil];
    
    _shouldForceStopNotification = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self teardownAVCapture];
    });
    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    _shouldForceStopNotification = NO;
    
    [super viewDidAppear:animated];
    
    [self initializeCamera];
    
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
    
    [self.menuButton removeTarget:[self revealViewController] action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton addTarget:[self revealViewController] action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

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
    
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, -4, self.upperBackgroundView.frame.size.width-100, self.upperBackgroundView.frame.size.height+4)];
        [titleLabel setFont:[UIFont fontWithName:@"Brannboll Fet" size:18.0]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"iCarTools0"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    [titleLabel setAlpha:0.0];
    [self.upperBackgroundView addSubview:titleLabel];
    
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
        [self.speedLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:40]];
        [self.speedLabel setTextAlignment:NSTextAlignmentRight];
        [self.speedLabel setTextColor:[UIColor whiteColor]];
        [self.speedLabel setText:@"0"];
        [self.view addSubview:self.speedLabel];
    }
    
    if (!self.speedUnitsLabel) {
        self.speedUnitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.view.frame.size.height-68-27, 25, 27)];
        [self.speedUnitsLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:10]];
        [self.speedUnitsLabel setTextAlignment:NSTextAlignmentCenter];
        [self.speedUnitsLabel setTextColor:[UIColor whiteColor]];
        [self updateSpeedUnitsLabel];
        [self.view addSubview:self.speedUnitsLabel];
    }
    
    if (!self.speedNotificationButton) {
        self.speedNotificationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.lowerBackgroundView.frame.origin.y+4, 79, 37)];
        [self.speedNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.speedNotificationButton.center.y)];
        [self.speedNotificationButton setImage:[UIImage imageNamed:@"suszarka"] forState:UIControlStateNormal];
        [self.speedNotificationButton addTarget:self action:@selector(submitSpeedCameraPosition) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.speedNotificationButton];
    }
    
    if (!self.crashNotificationButton) {
        self.crashNotificationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.whiteLine2.frame.origin.y+6, 79, 37)];
        [self.crashNotificationButton setCenter:CGPointMake(self.whiteLine2.center.x, self.crashNotificationButton.center.y)];
        [self.crashNotificationButton setImage:[UIImage imageNamed:@"wypadek"] forState:UIControlStateNormal];
        [self.crashNotificationButton addTarget:self action:@selector(submitAccidentPosition) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.crashNotificationButton];
    }
    
    if (!self.gpsStatusImageView) {
        self.gpsStatusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps_searching-256"]];
        [self.gpsStatusImageView setFrame:CGRectMake(0.0, self.whiteLine1.frame.origin.y+6, 37, 37)];
        [self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.gpsStatusImageView.center.y)];
        [self.view addSubview:self.gpsStatusImageView];
    }
    
    if (!gpsStatusLabel) {
        gpsStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(37+_whiteLine1.frame.origin.x, _whiteLine1.frame.origin.y+_whiteLine1.frame.size.height, _whiteLine1.frame.size.width-37, 46)];
        [gpsStatusLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:15.0]];
        [gpsStatusLabel setTextColor:[UIColor whiteColor]];
        [gpsStatusLabel setText:NSLocalizedString(@"Waiting", nil)];
        [gpsStatusLabel setTextAlignment:NSTextAlignmentCenter];
        [gpsStatusLabel setMinimumScaleFactor:0.7];
    }
    
    [gpsStatusLabel setAlpha:0.0];
    [self.view addSubview:gpsStatusLabel];
    
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
        titleLabel.alpha = 1.0;
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
        [self.gpsStatusImageView setFrame:CGRectMake(_whiteLine1.frame.origin.x, self.whiteLine1.frame.origin.y+6, 37, 37)];
        //[self.gpsStatusImageView setCenter:CGPointMake(self.whiteLine1.center.x, self.gpsStatusImageView.center.y)];
        [gpsStatusLabel setFrame:CGRectMake(37+_whiteLine1.frame.origin.x, _whiteLine1.frame.origin.y+_whiteLine1.frame.size.height, _whiteLine1.frame.size.width-37, 46)];
        gpsStatusLabel.alpha = 1.0;
        if (_trafficAlertView) {
            [_trafficAlertView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
        }
    });
}

- (void)setFramesForLandscapeLeft {
    dispatch_async(dispatch_get_main_queue(), ^{
        titleLabel.alpha = 0.0;
        gpsStatusLabel.alpha = 0.0;
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
        
        if (_trafficAlertView) {
            [_trafficAlertView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
        }
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
        
        if (startRecordingDate) {
            startRecordingDate = nil;
        }
        
        startRecordingDate = [self getStringDateFromCurrentDate];
        
        if (_pointsOnTheRouteArray) {
            if (_pointsOnTheRouteArray.count > 0) {
                [_pointsOnTheRouteArray removeAllObjects];
            }
        } else {
            _pointsOnTheRouteArray = [[NSMutableArray alloc] init];
        }
        
        [self orientationLock];
        [self startRecording];
    } else {
        _isRecording = NO;
        [self stopRecording];
        [self orientationUnlock];
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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
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
    
    
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [movieFile connectionWithMediaType:AVMediaTypeVideo];
    
    //Set landscape (if required)
    if ([CaptureConnection isVideoOrientationSupported])
    {
        switch ([[UIDevice currentDevice] orientation]) {
            case UIDeviceOrientationUnknown:
                CaptureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
            case UIDeviceOrientationPortrait:
                CaptureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
            case UIDeviceOrientationLandscapeLeft:
                CaptureConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIDeviceOrientationLandscapeRight:
                CaptureConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
                
            default:
                CaptureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
        }
    }
    
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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Please wait...", nil)];
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    } else {
        NSLog(@"did finish recording with error: %@", [error localizedDescription]);
    }
    
    if (RecordedSuccessfully)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library saveVideo:outputFileURL toAlbum:@"iCarTools" withCompletionBlock:^(ALAsset *asset) {
                if (_pointsOnTheRouteArray) {
                    
                    AVURLAsset *assetAV = [[AVURLAsset alloc] initWithURL:[asset valueForProperty:ALAssetPropertyAssetURL] options:nil];
                    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:assetAV];
                    generate.appliesPreferredTrackTransform = YES;
                    float duration = [[asset valueForProperty:ALAssetPropertyDuration] floatValue];
                    CMTime time = duration>=1 ? CMTimeMake(duration/2.0,1) : CMTimeMake(1, 1000);
                    CGImageRef thumbImg = [generate copyCGImageAtTime:time actualTime:NULL error:nil];
                    UIImage *thumbUIImage = [UIImage imageWithCGImage:thumbImg];
                    
                    UIImage *resizedThumb = [thumbUIImage scaleToSize:CGSizeMake(160, 160)];
                    
                    NSData *thumbData = UIImageJPEGRepresentation(resizedThumb, 0.8);
                    
                    NSDictionary *route = @{@"date" : startRecordingDate ? startRecordingDate : [self getStringDateFromCurrentDate],
                                            @"assetURL" : [asset valueForProperty:ALAssetPropertyAssetURL],
                                            @"route" : _pointsOnTheRouteArray,
                                            @"thumbnail" : thumbData};
                    
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/iCarTools/%@", [route objectForKey:@"date"]]];
                    
                    BOOL success = [NSKeyedArchiver archiveRootObject:route toFile:path];
                    
                    if (!success) {
                        NSLog(@"writeToFile failed with error %@", error);
                        [self showCantSaveVideoError];
                    } else {
                        NSLog(@"writeToFile success");
                    }
                    
                    startRecordingDate = nil;
                    [_pointsOnTheRouteArray removeAllObjects];
                    _pointsOnTheRouteArray = nil;
                    thumbImg = nil;
                    thumbUIImage = nil;
                    thumbData = nil;
                    resizedThumb = nil;
                    
                    
                    _pointsOnTheRouteArray = nil;
                    [DejalBezelActivityView removeViewAnimated:YES];
                }
            } andErrorBlock:^(NSError *error) {
                [self showCantSaveVideoError];
            }];
        } else {
            [self showCantSaveVideoError];
        }
    } else {
        [self showCantSaveVideoError];
    }
}

- (void)showCantSaveVideoError {
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                          message:NSLocalizedString(@"Can\'t save video", @"Couldn\'t add video input")
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles: nil];
    [myAlertView show];
    myAlertView = nil;
}

- (void) initializeCamera {
    //Capture Session
    
    if (!mCameraView) {
        mCameraView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    if (![mCameraView isDescendantOfView:self.view]) {
        [self.view insertSubview:mCameraView atIndex:0];
    }
    
    if (session==nil && device==nil && input==nil) {
        
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
                [self teardownAVCapture];
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
            [self teardownAVCapture];
            return;
        }
        
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error = nil;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"enableAudio"] == [NSNumber numberWithBool:YES]) {
            AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
            if (audioInput)
            {
                [session addInput:audioInput];
            }
        }
        
        
        movieFile = [[AVCaptureMovieFileOutput alloc] init];
        Float64 TotalSeconds = 3600;
        int32_t preferredTimeScale = 24;
        CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
        movieFile.maxRecordedDuration = maxDuration;
        
        movieFile.minFreeDiskSpaceLimit = 1024 * 1024 * 100;
        if ([session canAddOutput:movieFile])
            [session addOutput:movieFile];
        
        [supportedVideoQuality removeAllObjects];
        [supportedVideoQualityTranslatedNames removeAllObjects];
        if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [supportedVideoQuality addObject:AVCaptureSessionPreset1920x1080];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPreset1920x1080]];
        }
        if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [supportedVideoQuality addObject:AVCaptureSessionPreset1280x720];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPreset1280x720]];
        }
        if ([session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            [supportedVideoQuality addObject:AVCaptureSessionPreset640x480];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPreset640x480]];
        }
        if ([session canSetSessionPreset:AVCaptureSessionPreset352x288]) {
            [supportedVideoQuality addObject:AVCaptureSessionPreset352x288];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPreset352x288]];
        }
        if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            [supportedVideoQuality addObject:AVCaptureSessionPresetHigh];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPresetHigh]];
        }
        if ([session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
            [supportedVideoQuality addObject:AVCaptureSessionPresetMedium];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPresetMedium]];
        }
        if ([session canSetSessionPreset:AVCaptureSessionPresetLow]) {
            [supportedVideoQuality addObject:AVCaptureSessionPresetLow];
            [supportedVideoQualityTranslatedNames addObject:[self videoPresetName:AVCaptureSessionPresetLow]];
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"video quality"]) {
            [session setSessionPreset:[supportedVideoQuality objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"video quality"] intValue]]];
        } else {
            [session setSessionPreset:AVCaptureSessionPresetMedium];
        }
        
        [self startCamera];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    mCameraView.alpha = 0.0;
    if (_floatingAlertView) {
        _floatingAlertView.alpha = 0.0;
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setFramesForInterface:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    mCameraView.alpha = 0.0;
    
    if (_floatingAlertView) {
        [self hideFloatingAlertView];
    }
    
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
    if (![session isRunning]) {
        [session startRunning];
    }
    
    if (mCameraLayer) {
        [mCameraLayer removeFromSuperlayer];
        mCameraLayer = nil;
    }
    
    mCameraLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationUnknown:
            mCameraLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortrait:
            mCameraLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            mCameraLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            mCameraLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        default:
            mCameraLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    mCameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    mCameraLayer.frame = mCameraView.bounds;
    [mCameraView.layer addSublayer:mCameraLayer];
}

- (void)stopCamera
{
    [self teardownAVCapture];
}

- (void)toggleCamera
{
    session.isRunning ? [self stopCamera] : [self startCamera];
}

- (void)teardownAVCapture
{
    if (_isRecording) {
        _isRecording = NO;
        [self stopRecording];
    }
    
    if (movieFile) {
        [movieFile stopRecording];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    output = nil;
    
    [session removeInput:input];
    input = nil;
    
    device = nil;
    
    [session removeOutput:output];
    output = nil;
    [session stopRunning];
    session = nil;
    [mCameraLayer removeFromSuperlayer];
    mCameraLayer = nil;
    [mCameraView removeFromSuperview];
    mCameraView = nil;
    
}

#pragma mark- Obsługa przycisków zdarzeń
- (void)submitAccidentPosition {
    //accident_type_id 2
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isLogged"] == [NSNumber numberWithBool:YES] && [[UserInfo sharedInstance] login].length > 0) {
        CLLocationCoordinate2D location = [GPSUtilities sharedInstance].locationCoordinates;
        
        if (location.latitude != 0.0f && location.longitude != 0.0f) {
            
            [_crashNotificationButton setUserInteractionEnabled:NO];
            
            [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/addNewAccident.php?user_id=%d&accident_type_id=2&latitude=%f&longitude=%f&date=%@", [[UserInfo sharedInstance] user_id], location.latitude, location.longitude, [self getStringDateFromCurrentDate]]];
            
        } else {
            [self showFloatingAlertViewWithType:0];
        }
    } else {
        [self showFloatingAlertViewWithType:3];
    }
    
    
}

- (void)submitSpeedCameraPosition {
    //accident_type_id 1
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isLogged"] == [NSNumber numberWithBool:YES] && [[UserInfo sharedInstance] login].length > 0) {
        CLLocationCoordinate2D location = [GPSUtilities sharedInstance].locationCoordinates;
        
        if (location.latitude != 0.0f && location.longitude != 0.0f) {
            
            NSDateFormatter *df=[[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [df stringFromDate:[NSDate date]];
            
            [_speedNotificationButton setUserInteractionEnabled:NO];
            
            [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/addNewAccident.php?user_id=%d&accident_type_id=1&latitude=%f&longitude=%f&date=%@", [[UserInfo sharedInstance] user_id], location.latitude, location.longitude, dateString]];
            
            df = nil;
        } else {
            [self showFloatingAlertViewWithType:0];
        }
    } else {
        [self showFloatingAlertViewWithType:3];
    }
    
}

- (void)lockTrafficAccidentsButtons {
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(unlockTrafficAccidentsButtons) object:nil];
    [self performSelector:@selector(unlockTrafficAccidentsButtons) withObject:nil afterDelay:5.0];
    [_speedNotificationButton setUserInteractionEnabled:NO];
    [_crashNotificationButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [_speedNotificationButton setAlpha:0.5];
        [_crashNotificationButton setAlpha:0.5];
    }];
}

- (void)unlockTrafficAccidentsButtons {
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(unlockTrafficAccidentsButtons) object:nil];
    [_speedNotificationButton setUserInteractionEnabled:YES];
    [_crashNotificationButton setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [_speedNotificationButton setAlpha:1.0];
        [_crashNotificationButton setAlpha:1.0];
    }];
}

- (void)refreshDatabaseOfAccidents {
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDatabaseOfAccidents) object:nil];
    
    CLLocationCoordinate2D location = [GPSUtilities sharedInstance].locationCoordinates;
    
    if (location.latitude != 0.0f && location.longitude != 0.0f) {
        [[AmazingJSON sharedInstance] getResponseFromStringURL:[NSString stringWithFormat:@"http://bawsm.comlu.com/getAccidentList.php?latitude=%f&longitude=%f&diff=0.1", location.latitude, location.longitude]];
        
        _minDBLat = location.latitude - 0.1;
        _maxDBLat = location.latitude + 0.1;
        _minDBLong = location.longitude - 0.1;
        _maxDBLong = location.longitude + 0.1;
        
    } else {
        [self performSelector:@selector(refreshDatabaseOfAccidents) withObject:nil afterDelay:5];
        return;
    }
    
    [self performSelector:@selector(refreshDatabaseOfAccidents) withObject:nil afterDelay:5*60];
}

- (void)responseDictionary:(NSDictionary *)responseDict {
    //NSLog(@"%@", responseDict);
    
    if (responseDict == nil || [[responseDict objectForKey:@"code"] intValue] == 200) {
        [self showFloatingAlertViewWithType:0];
        [self unlockTrafficAccidentsButtons];
    } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
        [self lockTrafficAccidentsButtons];
        [self showFloatingAlertViewWithType:1];
    } else if ([[responseDict objectForKey:@"code"] intValue] == 401) {
        
        if (_shouldForceStopNotification == NO) {
            [self generateTrafficBagWithArray:[[responseDict objectForKey:@"response"] copy]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFloatingAlertViewWithType:2];
            });
        } else {
            _minDBLat = HUGE_VALF;
            _minDBLong = HUGE_VALF;
            _maxDBLat = -HUGE_VALF;
            _maxDBLong = -HUGE_VALF;
        }
    }
}

- (void)generateTrafficBagWithArray:(NSArray *)arrOfTrafficAccidents {
    
    if (_shouldForceStopNotification) {
        _minDBLat = HUGE_VALF;
        _minDBLong = HUGE_VALF;
        _maxDBLat = -HUGE_VALF;
        _maxDBLong = -HUGE_VALF;
        
        return;
    }
    
    if (_speedCameraBag) {
        _speedCameraBag = nil;
    }
    if (_crashAccidentBag) {
        _crashAccidentBag = nil;
    }
    
    _speedCameraBag = [NSBag bag];
    _crashAccidentBag = [NSBag bag];
    
    for (NSDictionary *dict in arrOfTrafficAccidents) {
        
        NSArray *loc = @[ [NSString stringWithFormat:@"%.3f", [[dict objectForKey:@"latitude"] floatValue]], [NSString stringWithFormat:@"%.3f", [[dict objectForKey:@"longitude"] floatValue]]];
        
        if ([[dict objectForKey:@"accident_type_id"] intValue] == 1) {
            //fotoradar
            [_speedCameraBag add:loc];
        } else if ([[dict objectForKey:@"accident_type_id"] intValue] == 2) {
            //wypadek
            [_crashAccidentBag add:loc];
        }
        
        loc = nil;
    }
    
    //NSLog(@"speed: %@", _speedCameraBag);
    //NSLog(@"acc: %@", _crashAccidentBag);
    
    [self generateDistanceToBagArray];
}

- (void)generateDistanceToBagArray {
    
    if (_shouldForceStopNotification) {
        _minDBLat = HUGE_VALF;
        _minDBLong = HUGE_VALF;
        _maxDBLat = -HUGE_VALF;
        _maxDBLong = -HUGE_VALF;
        
        return;
    }
    
    NSMutableArray *distanceToSpeedBagArray = [[NSMutableArray alloc] init];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[[GPSUtilities sharedInstance] locationCoordinates].latitude longitude:[[GPSUtilities sharedInstance] locationCoordinates].longitude];
    
    for (int i=0; i<[[_speedCameraBag objects] count]; i++) {
        NSArray *locArr = [[_speedCameraBag objects] objectAtIndex:i];
        
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[locArr objectAtIndex:0] floatValue] longitude:[[locArr objectAtIndex:1] floatValue]];
        CLLocationDistance meters = [newLocation distanceFromLocation:currentLocation];
        
        [distanceToSpeedBagArray addObject:@[[NSNumber numberWithDouble:meters], locArr]];
    }
    
    NSMutableArray *distanceToAccidentBagArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[[_crashAccidentBag objects] count]; i++) {
        NSArray *locArr = [[_crashAccidentBag objects] objectAtIndex:i];
        
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[locArr objectAtIndex:0] floatValue] longitude:[[locArr objectAtIndex:1] floatValue]];
        CLLocationDistance meters = [newLocation distanceFromLocation:currentLocation];
        
        [distanceToAccidentBagArray addObject:@[[NSNumber numberWithDouble:meters], locArr]];
    }
    
    //find minimum index
    if (_speedCameraSortedArray) {
        _speedCameraSortedArray = nil;
    }
    _speedCameraSortedArray = [NSMutableArray arrayWithArray:[distanceToSpeedBagArray sortedArrayUsingComparator:^(NSArray *obj1,NSArray *obj2) {
        NSString *num1 =[NSString stringWithFormat:@"%f", [[obj1 objectAtIndex:0] floatValue]];
        NSString *num2 =[NSString stringWithFormat:@"%f", [[obj2 objectAtIndex:0] floatValue]];
        return (NSComparisonResult) [num1 compare:num2 options:(NSNumericSearch)];
    }]];
    
    if (_crashAccidentSortedArray) {
        _crashAccidentSortedArray = nil;
    }
    _crashAccidentSortedArray = [NSMutableArray arrayWithArray:[distanceToAccidentBagArray sortedArrayUsingComparator:^(NSArray *obj1,NSArray *obj2) {
        NSString *num1 =[NSString stringWithFormat:@"%f", [[obj1 objectAtIndex:0] floatValue]];
        NSString *num2 =[NSString stringWithFormat:@"%f", [[obj2 objectAtIndex:0] floatValue]];
        return (NSComparisonResult) [num1 compare:num2 options:(NSNumericSearch)];
    }]];
    
    [self notifyUserAboutNearestAccident];
}

- (void)notifyUserAboutNearestAccident {
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyUserAboutNearestAccident) object:nil];
    
    if (_shouldForceStopNotification) {
        _minDBLat = HUGE_VALF;
        _minDBLong = HUGE_VALF;
        _maxDBLat = -HUGE_VALF;
        _maxDBLong = -HUGE_VALF;
        
        return;
    }
    
    NSLog(@"%@", _speedCameraSortedArray);
    NSLog(@"%@", _crashAccidentSortedArray);
    
    if (_speedCameraSortedArray.count == 0 && _crashAccidentSortedArray.count == 0) {
        return;
    }
    
    if (_speedCameraSortedArray && _crashAccidentSortedArray) {
        if (_speedCameraSortedArray.count > 0 || _crashAccidentSortedArray.count > 0) {
            CLLocationDistance nearestPointDistance = HUGE_VALF;
            NSArray *finalLoc = nil;
            int whichArray = -1;
            if (_speedCameraSortedArray.count > 0) {
                
                whichArray = 10;
                
                NSArray *tmpArray = [_speedCameraSortedArray firstObject];
                
                nearestPointDistance = [[tmpArray objectAtIndex:0] doubleValue];
                finalLoc = [tmpArray objectAtIndex:1];
                
            }
            
            if (_crashAccidentSortedArray.count > 0) {
                if ([[[_crashAccidentSortedArray firstObject] objectAtIndex:0] doubleValue] < nearestPointDistance || finalLoc == nil) {
                    
                    whichArray = 20;
                    
                    NSArray *tmpArray = [_crashAccidentSortedArray firstObject];
                    
                    nearestPointDistance = [[tmpArray objectAtIndex:0] doubleValue];
                    if (finalLoc) {
                        finalLoc = nil;
                    }
                    finalLoc = [tmpArray objectAtIndex:1];
                }
            }
            
            if (nearestPointDistance < 500) {
                
                if (_shouldForceStopNotification) {
                    _minDBLat = HUGE_VALF;
                    _minDBLong = HUGE_VALF;
                    _maxDBLat = -HUGE_VALF;
                    _maxDBLong = -HUGE_VALF;
                    
                    return;
                }
                
                if (whichArray == 10) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showTrafficAlertWithDistance:nearestPointDistance mode:0 andArrayOfCoordinates:finalLoc];
                    });
                    [_speedCameraSortedArray removeObjectAtIndex:0];
                } else if (whichArray == 20) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showTrafficAlertWithDistance:nearestPointDistance mode:1 andArrayOfCoordinates:finalLoc];
                    });
                    [_crashAccidentSortedArray removeObjectAtIndex:0];
                }
            }
            
        }
    }
    
    [self performSelector:@selector(notifyUserAboutNearestAccident) withObject:nil afterDelay:10.0];
}

- (void)showTrafficAlertWithDistance:(CLLocationDistance)distance mode:(int)mode andArrayOfCoordinates:(NSArray *)coordinates {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTrafficAlert) object:nil];
    
    if (_shouldForceStopNotification) {
        _minDBLat = HUGE_VALF;
        _minDBLong = HUGE_VALF;
        _maxDBLat = -HUGE_VALF;
        _maxDBLong = -HUGE_VALF;
        
        return;
    }
    
    if (_trafficAlertView) {
        if ([_trafficAlertView isDescendantOfView:self.view]) {
            [_trafficAlertView removeFromSuperview];
        }
        _trafficAlertView = nil;
    }
    
    _trafficAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [_trafficAlertView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [_trafficAlertView.layer setCornerRadius:10.0];
    [_trafficAlertView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
    UIImageView *alertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 40, 100, 100)];
    [alertImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if (mode == 0) {
        [alertImageView setImage:[UIImage imageNamed:@"suszarka"]];
    } else if (mode == 1) {
        [alertImageView setImage:[UIImage imageNamed:@"wypadek"]];
    }
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 180, 30)];
    [distanceLabel setFont:[UIFont fontWithName:@"DINPro-Light" size:20]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setTextAlignment:NSTextAlignmentCenter];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setText:[NSString stringWithFormat:@"%@%.2fm", NSLocalizedString(@"Distance: ", nil), distance]];
    
    _trafficAlertView.alpha = 0.0;
    [self.view addSubview:_trafficAlertView];
    [_trafficAlertView addSubview:alertImageView];
    [_trafficAlertView addSubview:distanceLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        _trafficAlertView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideTrafficAlert) withObject:nil afterDelay:4.0];
    }];
    
    distanceLabel = nil;
    alertImageView = nil;
    
}

- (void)hideTrafficAlert {
    if (_trafficAlertView) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _trafficAlertView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [_trafficAlertView removeFromSuperview];
            _trafficAlertView = nil;
        }];
    }
}

/**
 *  @Author Michał Czwarnowski
 *
 *  Wyświetla pięciosekundowy alert
 *
 *  @param type 0 - błąd, 1 - poprawne dodanie zdarzenia, 2 - odświeżenie info z bazy, 3 - niezalogowany
 */
- (void)showFloatingAlertViewWithType:(int)type {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFloatingAlertView) object:nil];
    
    if (_floatingAlertView) {
        if ([_floatingAlertView isDescendantOfView:self.view]) {
            [_floatingAlertView removeFromSuperview];
        }
        _floatingAlertView = nil;
    }
    
    float height = 30.0f;
    
    _floatingAlertView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280.0)/2, ([[UIDevice currentDevice] orientation] != UIDeviceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIDeviceOrientationLandscapeRight) ? _upperBackgroundView.frame.size.height - height : -height, 280.0, height)];
    _floatingAlertView.alpha = 0.0f;
    [_floatingAlertView.layer setCornerRadius:5.0f];
    UILabel *floatingViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 270.0, height)];
    [floatingViewLabel setTextAlignment:NSTextAlignmentCenter];
    
    switch (type) {
        case 0:
            [floatingViewLabel setText:NSLocalizedString(@"Error occured. Please try again", nil)];
            [_floatingAlertView setBackgroundColor:[UIColor redColor]];
            break;
        case 1:
            [floatingViewLabel setText:NSLocalizedString(@"Accident added successfully.", nil)];
            [_floatingAlertView setBackgroundColor:[UIColor greenColor]];
            break;
        case 2:
            [floatingViewLabel setText:NSLocalizedString(@"Database refreshed.", nil)];
            [_floatingAlertView setBackgroundColor:[UIColor greenColor]];
            break;
        case 3:
            [floatingViewLabel setText:NSLocalizedString(@"You must be logged in to send traffic info.", nil)];
            [_floatingAlertView setBackgroundColor:[UIColor redColor]];
            break;
            
        default:
            break;
    }
    
    [floatingViewLabel setTextColor:[UIColor whiteColor]];
    [_floatingAlertView addSubview:floatingViewLabel];
    
    [self.view insertSubview:_floatingAlertView belowSubview:_upperBackgroundView];
    floatingViewLabel = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        _floatingAlertView.alpha = 1.0f;
        [_floatingAlertView setFrame:CGRectMake((self.view.frame.size.width-280.0)/2, ([[UIDevice currentDevice] orientation] != UIDeviceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIDeviceOrientationLandscapeRight) ? _upperBackgroundView.frame.size.height + 5.0 : 5.0, 280.0, height)];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideFloatingAlertView) withObject:nil afterDelay:4.0];
    }];
    
}

- (void)hideFloatingAlertView {
    if (_floatingAlertView) {
        float height = 30.0f;
        
        [UIView animateWithDuration:0.5 animations:^{
            _floatingAlertView.alpha = 0.0f;
            _floatingAlertView.frame = CGRectMake(_floatingAlertView.frame.origin.x, _floatingAlertView.frame.origin.y - height, _floatingAlertView.frame.size.width, _floatingAlertView.frame.size.height);
        } completion:^(BOOL finished) {
            _floatingAlertView.frame = CGRectMake((self.view.frame.size.width-280.0)/2, ([[UIDevice currentDevice] orientation] != UIDeviceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIDeviceOrientationLandscapeRight) ? _upperBackgroundView.frame.size.height - height : -height, 280.0, height);
            
            [_floatingAlertView removeFromSuperview];
            _floatingAlertView = nil;
        }];
    }
}

#pragma mark- GPSUtilities Delegates
- (void)locationUpdate:(CLLocation *)location {
    float speedInMetersPerSecond = location.speed;
    int speedInKilometersPerHour = speedInMetersPerSecond * 3600 / 1000;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (speedInKilometersPerHour >= 0) {
            [self.speedLabel setText:[NSString stringWithFormat:@"%d", speedInKilometersPerHour*speedCalculator]];
        } else {
            [self.speedLabel setText:@"0"];
        }
    });
    
    if (location.coordinate.latitude >= _minDBLat && location.coordinate.latitude <= _maxDBLat && location.coordinate.longitude >= _minDBLong && location.coordinate.longitude <= _maxDBLat) {
        //jesteśmy w kwadracie, no update
    } else {
         [self performSelector:@selector(refreshDatabaseOfAccidents) withObject:nil afterDelay:5.0];
    }
    
    if (_isRecording && _pointsOnTheRouteArray) {
        NSLog(@"Dodano lokalizację: %@", location);
        [_pointsOnTheRouteArray addObject:location];
    }
}

- (void)locationError:(NSError *)error {
    NSLog(@"Location error: %@", [error localizedDescription]);
}

- (void)gpsDidChangeState:(int)state {
    
    self.gpsStatusImageView.image = nil;
    if (state == 2) {
        self.gpsStatusImageView.image = [UIImage imageNamed:@"gps_receiving-256"];
        [gpsStatusLabel setText:NSLocalizedString(@"GPS OK", nil)];
        [self performSelector:@selector(refreshDatabaseOfAccidents) withObject:nil afterDelay:5.0];
        
    } else if (state == 1) {
        self.gpsStatusImageView.image = [UIImage imageNamed:@"gps_searching-256"];
        [gpsStatusLabel setText:NSLocalizedString(@"Waiting", nil)];
    } else {
        self.gpsStatusImageView.image = [UIImage imageNamed:@"gps_disconnected-256"];
        [gpsStatusLabel setText:NSLocalizedString(@"Disconnected", nil)];
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

- (void)exit {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTrafficAlert) object:nil];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyUserAboutNearestAccident) object:nil];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDatabaseOfAccidents) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFloatingAlertView) object:nil];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(unlockTrafficAccidentsButtons) object:nil];
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(unlockTrafficAccidentsButtons) object:nil];
    [self teardownAVCapture];
    [self.gpsUtilities stopGPS];
    self.gpsUtilities.delegate = nil;
    self.gpsUtilities = nil;
    [_pointsOnTheRouteArray removeAllObjects];
    _pointsOnTheRouteArray = nil;
    [self orientationUnlock];
    [((SettingsViewController *)self.revealViewController.rearViewController) setDelegate:nil];
    [self.revealViewController setFrontViewController:_parentView animated:YES];
    _parentView = nil;
}

- (NSString *)getStringDateFromCurrentDate {
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:[NSDate date]];
    df = nil;
    return dateString;
}

#pragma mark- SettingsViewController
- (void)clickedOption:(int)number inMenuType:(int)menuType {
    
    /*NSLocalizedString(@"Recorded videos", nil),
     NSLocalizedString(@"Enable sound", nil),
     NSLocalizedString(@"Video quality", nil),
     NSLocalizedString(@"Speed unit", nil)]]*/
    
    if (menuType == 0) {
        switch (number) {
            case 0:
                [self showRecordedVideosList];
                break;
            case 1:
                [self showEnableSoundList];
                break;
            case 2:
                [self showVideoQualityList];
                break;
            case 3:
                [self showSpeedUnitSettings];
                break;
                
            default:
                break;
        }
    } else if (menuType == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool: number == 0 ? YES : NO] forKey:@"enableAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        didChangeCameraSettings = YES;
        [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated:YES];
        [self updateDataSourceInLeftRevealViewController];
        
    } else if (menuType == 2) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:number] forKey:@"video quality"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        didChangeCameraSettings = YES;
        [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated:YES];
        [self updateDataSourceInLeftRevealViewController];

    } else if (menuType == 3) {
        
        [[NSUserDefaults standardUserDefaults] setObject: number == 0 ? @"km/h" : @"mph" forKey:@"speed unit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateSpeedUnitsLabel];
        [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated:YES];
        [self updateDataSourceInLeftRevealViewController];
    }
    
}


- (void)showRecordedVideosList {
    RecordedVideosViewController *recordedVideos = [[RecordedVideosViewController alloc] init];
    recordedVideos.parentView = self;
    [self.revealViewController pushFrontViewController:recordedVideos animated:YES];
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self teardownAVCapture];
    });
    */
    recordedVideos = nil;
}

- (void)showEnableSoundList {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[
                                                                                                              NSLocalizedString(@"YES", nil),
                                                                                                              NSLocalizedString(@"NO", nil)]
                                                                                        indexOfActiveOption:[[NSUserDefaults standardUserDefaults] objectForKey:@"enableAudio"] == [NSNumber numberWithBool:YES] ? 0 : 1 andMenuType:1];
    }
}

- (void)showVideoQualityList {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:supportedVideoQualityTranslatedNames indexOfActiveOption:[[[NSUserDefaults standardUserDefaults] objectForKey:@"video quality"] intValue] andMenuType:2];
    }
}

- (void)showSpeedUnitSettings {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [self.revealViewController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[
                                                                                NSLocalizedString(@"km/h", nil),
                                                                                NSLocalizedString(@"mph", nil)]
                                                                                                indexOfActiveOption:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speed unit"] isEqualToString: @"km/h"] ? 0 : 1 andMenuType:3];
    }
}

#pragma mark- Update After Settings Changes
- (void)settingsViewWillDisappear {
    if (didChangeCameraSettings) {
        didChangeCameraSettings = NO;
        [self updateCamera];
    }
}

- (void)updateDataSourceInLeftRevealViewController {
    if ([self.revealViewController.rearViewController isKindOfClass:NSClassFromString(@"SettingsViewController")]) {
        [((SettingsViewController *)self.revealViewController.rearViewController) updateMenuWithTitlesArray:@[
                                                                                                              NSLocalizedString(@"Recorded videos", nil),
                                                                                                              NSLocalizedString(@"Enable sound", nil),
                                                                                                              NSLocalizedString(@"Video quality", nil),
                                                                                                              NSLocalizedString(@"Speed unit", nil)]
                                                                                                andMenuType:0];
    }
}

- (void)updateSpeedUnitsLabel {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"speed unit"] isEqualToString:@"km/h"]) {
        speedCalculator = 1;
        [self.speedUnitsLabel setText:@"km/h"];
    } else {
        speedCalculator = 0.621371192;
        [self.speedUnitsLabel setText:@"mph"];
    }
}

- (void)updateCamera {
    didChangeCameraSettings = NO;
    [self teardownAVCapture];
    [self initializeCamera];
}

#pragma mark- Blokowanie obracania na czas nagrywania
-(void) orientationLock {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = YES;
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationUnknown:
            appDelegate.lockedOrientation = UIInterfaceOrientationMaskPortrait;
            break;
        case UIDeviceOrientationPortrait:
            appDelegate.lockedOrientation = UIInterfaceOrientationMaskPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            appDelegate.lockedOrientation = UIInterfaceOrientationMaskLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            appDelegate.lockedOrientation = UIInterfaceOrientationMaskLandscapeLeft;
            break;
            
        default:
            appDelegate.lockedOrientation = UIInterfaceOrientationMaskPortrait;
            break;
    }
}

-(void) orientationUnlock {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    if (_isRecording) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)videoPresetName:(NSString *)presetName {
    if ([presetName isEqualToString:AVCaptureSessionPreset1920x1080]) {
        return @"1920x1080";
    } else if ([presetName isEqualToString:AVCaptureSessionPreset1280x720]) {
        return @"1280x720";
    } else if ([presetName isEqualToString:AVCaptureSessionPreset640x480]) {
        return @"640x480";
    } else if ([presetName isEqualToString:AVCaptureSessionPreset352x288]) {
        return @"352x288";
    } else if ([presetName isEqualToString:AVCaptureSessionPresetHigh]) {
        return NSLocalizedString(@"High preset", nil);
    } else if ([presetName isEqualToString:AVCaptureSessionPresetMedium]) {
        return NSLocalizedString(@"Medium preset", nil);
    } else if ([presetName isEqualToString:AVCaptureSessionPresetLow]) {
        return NSLocalizedString(@"Low preset", nil);
    } else {
        return @"Unknown";
    }
}

@end