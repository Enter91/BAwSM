//
//  GPSUtilities.h
//  Wideo Rejestrator
//
//  Created by Michał Czwarnowski on 13.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@protocol GPSUtilitiesDelegate <NSObject>

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end

@interface GPSUtilities : NSObject <CLLocationManagerDelegate>

/**
 * gets singleton object.
 * @return singleton
 */
+ (GPSUtilities*)sharedInstance;

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, assign) id delegate;

@end
