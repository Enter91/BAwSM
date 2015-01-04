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

/**
 *  @author Michał Czwarnowski
 *
 *  Określa stan w jakim jest aktualnie GPS
 *
 *  @param state 0 - GPS error, 1 - szukam GPSa, 2 - GPS aktywny
 */
- (void)gpsDidChangeState:(int)state;

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
 *  Sprawdza dostęp do GPSa i wyświetla systemowy komunikat z prośbą o dostęp, jeżeli status inny niż Authorized i Denied
 *
 *  @return Dostęp do GPSa
 */
- (BOOL)askPermission;

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
@property CLLocationCoordinate2D locationCoordinates;
@property (nonatomic) BOOL isDistanceFilterEnable;
@property (nonatomic) int state;

@end
