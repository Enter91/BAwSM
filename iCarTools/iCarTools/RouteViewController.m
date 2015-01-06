//
//  RouteViewController.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 04.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "RouteViewController.h"
#import "AppDelegate.h"

@interface RouteViewController ()

@property (strong, nonatomic) NSArray *arrayOfPoints;
@property (strong, nonatomic) NSString *dateString;

@end

@implementation RouteViewController

- (instancetype)initWithRoutePointsArray:(NSArray *)points {
    self = [super init];
    if (self) {
        _wantsCustomAnimation = YES;
        
        _arrayOfPoints = [NSArray arrayWithArray:points];
        
    }
    return self;
}

- (instancetype)initWithRoutePointsArray:(NSArray *)points andDateString:(NSString *)dateString {
    self = [super init];
    if (self) {
        _wantsCustomAnimation = YES;
        
        _arrayOfPoints = [NSArray arrayWithArray:points];
        _dateString = [NSString stringWithString:dateString];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(showShareActionSheet)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Route", nil)];
    navigationItem.leftBarButtonItem = barButton;
    navigationItem.rightBarButtonItem = rightBarButton;
    [_navigationBar pushNavigationItem:navigationItem animated:NO];
    
    _mapView.delegate = self;
    
    [_mapView setRegion:MKCoordinateRegionForMapRect([self getZoomMapToRouteRegion:_mapView]) animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientationIsLocked = NO;
    
    [self showRoute];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.revealViewController.panGestureRecognizer.enabled = NO;
    self.revealViewController.tapGestureRecognizer.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) cancelAction:(id)sender {
    self.mapView.delegate = nil;
    [self.revealViewController setFrontViewController:_parentView animated:YES];
    _parentView = nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 5.0;
    
    return polylineView;
}

- (void)showRoute {
    
    int numPoints = (int)_arrayOfPoints.count;
    
    CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < numPoints; i++)
    {
        CLLocation* current = [_arrayOfPoints objectAtIndex:i];
        coords[i] = current.coordinate;
    }
    
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:numPoints];
    free(coords);
    
    [_mapView addOverlay:line];

}

- (MKMapRect)getZoomMapToRouteRegion:(MKMapView *)map {
    
    CLLocationDegrees minLatitude = HUGE_VALF;
    CLLocationDegrees minLongitude = HUGE_VALF;
    CLLocationDegrees maxLatitude = -HUGE_VALF;
    CLLocationDegrees maxLongitude = -HUGE_VALF;
    
    for (CLLocation *route in _arrayOfPoints) {
        if (route.coordinate.latitude < minLatitude) {
            minLatitude = route.coordinate.latitude;
        }
        
        if (route.coordinate.longitude < minLongitude) {
            minLongitude = route.coordinate.longitude;
        }
        
        if (route.coordinate.latitude > maxLatitude) {
            maxLatitude = route.coordinate.latitude;
        }
        
        if (route.coordinate.longitude > maxLongitude) {
            maxLongitude = route.coordinate.longitude;
        }
    }
    
    MKMapPoint nePoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(maxLatitude+0.001, maxLongitude+0.001));
    MKMapPoint swPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(minLatitude-0.001, minLongitude-0.001));
    CGFloat width = ABS(nePoint.x - swPoint.x);
    CGFloat height = ABS(nePoint.y - swPoint.y);
    MKMapRect newMapRect = MKMapRectMake(
                                         MIN(swPoint.x, nePoint.x),
                                         MIN(swPoint.y, nePoint.y),
                                         width, 
                                         height
                                         );
    
    return newMapRect;
}

- (void)showShareActionSheet {
    
    [_mapView setRegion:MKCoordinateRegionForMapRect([self getZoomMapToRouteRegion:_mapView]) animated:NO];
    UIImage *mapImage = [self captureView:_mapView];

    [self shareText:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"This is my route recorded in iCarTools app on ", nil), _dateString] andImage:mapImage andUrl:nil];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (UIImage *)captureView:(UIView *)view {
    CGRect screenRect = view.frame;
    
    UILabel *iCarToolsLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 60)];
    [iCarToolsLogoLabel setText:@"iCarTools0"];
    [iCarToolsLogoLabel setFont:[UIFont fontWithName:@"Brannboll Fet" size:25]];
    [iCarToolsLogoLabel setTextColor:[UIColor whiteColor]];
    iCarToolsLogoLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    iCarToolsLogoLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    iCarToolsLogoLabel.layer.shadowOpacity = 1.0f;
    iCarToolsLogoLabel.layer.shadowRadius = 1.0f;
    [view addSubview:iCarToolsLogoLabel];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [iCarToolsLogoLabel removeFromSuperview];
    iCarToolsLogoLabel = nil;
    
    return newImage;
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
