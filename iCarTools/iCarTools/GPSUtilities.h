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

/**
 *  @Author Michał Czwarnowski
 *
 *  Uruchamia GPS
 */
- (void)startGPS;

/**
 *  @Author Michał Czwarnowski
 *
 *  Uruchamia GPS z zadaną dokładnością pomiaru
 *
 *  @param accuracy Precyzja GPSa
 */
- (void)startGPSWithAccuracy:(CLLocationAccuracy)accuracy;

/**
 *  @Author Michał Czwarnowski
 *
 *  Zatrzymuje GPS
 */
- (void)stopGPS;

/**
 *  @Author Michał Czwarnowski
 *
 *  Pozwala na zmianę precyzji w trakcie działania GPSa
 *
 *  @param accuracy Precyzja GPSa
 */
- (void)setAccuracy:(CLLocationAccuracy)accuracy;

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, assign) id delegate;

@end
