//
//  UserInfo.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 01.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

@import Foundation;

@interface UserInfo : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (UserInfo*)sharedInstance;

- (void)setUserInfoWithLogin:(int)user_id login:(NSString *)login firstName:(NSString *)firstName lastName:(NSString *)lastName andEmail:(NSString *)email;
- (void)clearAllData;

@property (nonatomic) int user_id;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *email;


@end
