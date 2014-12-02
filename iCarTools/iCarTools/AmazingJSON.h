//
//  AmazingJSON.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 02.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

@import Foundation;

@protocol AmazingJSONDelegate <NSObject>

- (void)responseDictionary: (NSDictionary *)responseDict;

@end

@interface AmazingJSON : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (AmazingJSON*)sharedInstance;

- (void)getResponseFromURL:(NSURL *)url;

@property (nonatomic, assign) id delegate;

@end
