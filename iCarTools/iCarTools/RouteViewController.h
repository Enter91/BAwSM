//
//  RouteViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 04.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SWRevealViewController.h>

@interface RouteViewController : UIViewController <UINavigationControllerDelegate, MKMapViewDelegate>

- (instancetype)initWithRoutePointsArray:(NSArray *)points;
- (instancetype)initWithRoutePointsArray:(NSArray *)points andDateString:(NSString *)dateString;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic) BOOL wantsCustomAnimation;
@property (nonatomic, strong) UIViewController *parentView;

@end
