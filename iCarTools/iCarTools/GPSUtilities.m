//
//  GPSUtilities.m
//  Wideo Rejestrator
//
//  Created by Michał Czwarnowski on 13.10.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "GPSUtilities.h"

@implementation GPSUtilities

static GPSUtilities *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[GPSUtilities alloc] init];
}

- (id)mutableCopy
{
    return [[GPSUtilities alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    
    if (self) {
        if (!self.locManager) {
            self.locManager = [[CLLocationManager alloc] init];
        }
        self.locManager.delegate = self;
        _locationCoordinates = CLLocationCoordinate2DMake(0.0f, 0.0f);
    }
    
    return self;
}

- (BOOL)askPermission {
    if([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            if ([self.locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locManager requestWhenInUseAuthorization];
            }
            
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    
    return NO;
}

- (void)startGPS {
    if (!self.locManager) {
        self.locManager = [[CLLocationManager alloc] init];
    }
    self.locManager.delegate = self;
    
    if( [CLLocationManager locationServicesEnabled] &&  [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        if ([self.locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locManager requestWhenInUseAuthorization];
        }
        
        [self.locManager startUpdatingLocation];
    }
}

- (void)startGPSWithAccuracy:(CLLocationAccuracy)accuracy {
    [self startGPS];
    [self setAccuracy:accuracy];
}

- (void)stopGPS {
    if (self.locManager) {
        if ([self.locManager respondsToSelector:@selector(stopUpdatingLocation)]) {
            self.locManager.delegate = nil;
            [self.locManager stopUpdatingLocation];
        }
    }
}

- (void)setAccuracy:(CLLocationAccuracy)accuracy {
    if (self.locManager) {
        if ([self.locManager respondsToSelector:@selector(setDesiredAccuracy:)]) {
            [self.locManager setDesiredAccuracy:accuracy];
        }
    }
}

#pragma mark- CLLocationManager Delegaty
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (self.delegate) {
        if([self.delegate conformsToProtocol:@protocol(GPSUtilitiesDelegate)])
        {
            _locationCoordinates = newLocation.coordinate;
            [self.delegate locationUpdate:newLocation];
        }
    } else {
        [self stopGPS];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.delegate) {
        if([self.delegate conformsToProtocol:@protocol(GPSUtilitiesDelegate)])
        {
            [self.delegate locationError:error];
        }
    } else {
        [self stopGPS];
    }
}


@end
