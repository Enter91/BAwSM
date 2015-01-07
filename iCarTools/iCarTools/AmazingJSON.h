//
//  AmazingJSON.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 02.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

@import Foundation;

@protocol AmazingJSONDelegate <NSObject>

/**
 *  @Author Michał Czwarnowski
 *
 *  Przekazuje odpowiedź z serwera jako NSDictionary
 *
 *  @param responseDict Obiekt zwrócony z serwera po zapytaniu
 */
- (void)responseDictionary: (NSDictionary *)responseDict;

@end

@interface AmazingJSON : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (AmazingJSON*)sharedInstance;

/**
 *  @Author Michał Czwarnowski
 *
 *  Przesyła zapytanie do serwera pod wskazany adres URL
 *
 *  @param url URL zapytania
 */
- (void)getResponseFromURL:(NSURL *)url;

/**
 *  @Author Michał Czwarnowski
 *
 *  Przesyła zapytanie do serwera pod wskazany w zmiennej NSString adres
 *
 *  @param stringURL Adres zapytania jako NSString
 */
- (void)getResponseFromStringURL:(NSString *)stringURL;

@property (nonatomic, assign) id delegate;

@end
