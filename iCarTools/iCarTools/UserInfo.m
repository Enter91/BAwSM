//
//  UserInfo.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 01.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *SINGLETON = nil;

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
    return [[UserInfo alloc] init];
}

- (id)mutableCopy
{
    return [[UserInfo alloc] init];
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
    return self;
}

- (void)setUserInfoWithLogin:(int)user_id login:(NSString *)login firstName:(NSString *)firstName lastName:(NSString *)lastName andEmail:(NSString *)email {
    _user_id = user_id;
    _login = [NSString stringWithString:login];
    _first_name = [NSString stringWithString:firstName];
    _last_name = [NSString stringWithString:lastName];
    _email = [NSString stringWithString:email];
}

- (void)clearAllData {
    _user_id = -1;
    _login = nil;
    _first_name = nil;
    _last_name = nil;
    _email = nil;
}

@end
