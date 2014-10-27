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
        
        if( [CLLocationManager locationServicesEnabled] &&  [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        {
            if ([self.locManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locManager requestAlwaysAuthorization];
            }
            
            [self.locManager startUpdatingLocation];
        }
    }
    
    return self;
}

#pragma mark- CLLocationManager Delegaty
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if([self.delegate conformsToProtocol:@protocol(GPSUtilitiesDelegate)])
    {
        [self.delegate locationUpdate:newLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if([self.delegate conformsToProtocol:@protocol(GPSUtilitiesDelegate)])
    {
        [self.delegate locationError:error];
    }
}


@end
