//
//  FixedCompassLayout.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 25.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FixedCompassLayout : NSObject <UILayoutSupport>

@property (nonatomic) CGFloat pbLength;
@property (nonatomic) CGFloat pbHeight;
- (id)initWithLength:(CGFloat)length andHeight:(CGFloat)height;

@end
