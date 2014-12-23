//
//  AmazingJSON.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 02.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "AmazingJSON.h"

@implementation AmazingJSON

static AmazingJSON *SINGLETON = nil;

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
    return [[AmazingJSON alloc] init];
}

- (id)mutableCopy
{
    return [[AmazingJSON alloc] init];
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

- (void)getResponseFromURL:(NSURL *)url {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)getResponseFromStringURL:(NSString *)stringURL {
    
    NSURL *url = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
}

- (void)fetchedData:(NSData *)responseData {
    
    NSError* error;
    
    if (responseData) {
        NSObject *object = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        
        if (object != nil) {
            NSString *json = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
            
            NSRange range = [json rangeOfString:@"{"];
            json = [json substringFromIndex:range.location];
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+<!--.*$" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
            
            NSTextCheckingResult *result = [regex firstMatchInString:json options:0 range:NSMakeRange(0, json.length)];
            if(result) {
                NSRange range = [result rangeAtIndex:0];
                json = [json stringByReplacingCharactersInRange:range withString:@""];
                
                NSRange rangeOfArray = [json rangeOfString:@"{"];
                NSString *newString = [json substringWithRange:NSMakeRange(rangeOfArray.location, json.length - rangeOfArray.location)];
                
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[newString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                json = nil;
                
                [_delegate responseDictionary:dictionary];
            } else {
                 NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                json = nil;
                
                [_delegate responseDictionary:dictionary];
                
            }
        } else {
            [_delegate responseDictionary:nil];
        }
    } else {
        [_delegate responseDictionary:nil];
    }
}

@end
