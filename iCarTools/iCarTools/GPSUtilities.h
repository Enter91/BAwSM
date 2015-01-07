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

/**
 *  @Author Michał Czwarnowski
 *
 *  Przesyła w parametrze najnowszą odebraną lokalizację
 *
 *  @param location Ostatnio odebrana lokalizacja
 */
- (void)locationUpdate:(CLLocation *)location;

/**
 *  @Author Michał Czwarnowski
 *
 *  Przesyła w parametrze błąd odczytu GPSa
 *
 *  @param error Błąd odczytu nowej lokalizacji
 */
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
 *  @return Flaga określająca pozwolenie na korzystanie z GPSa
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

@property (nonatomic, assign) id delegate;
/**
 *  @Author Michał Czwarnowski
 *
 *  Ostatnie odebrane współrzędne
 */
@property CLLocationCoordinate2D locationCoordinates;

/**
 *  @Author Michał Czwarnowski
 *
 *  Włącza lub wyłącza filtrowanie wyników GPS. Jeżeli włączony, GPS nie będzie generował nowych komunikatów jeżeli kolejny odczyt nastąpi w promieniu 50 metrów.
 */
@property (nonatomic) BOOL isDistanceFilterEnable;


@end
