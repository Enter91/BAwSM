//
//  FixedCompassLayout.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 25.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "FixedCompassLayout.h"

@implementation FixedCompassLayout

- (id)initWithLength:(CGFloat)length andHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        _pbLength = length;
        _pbHeight = height;
    }
    return self;
}

- (CGFloat)length {
    return _pbLength;
}

- (CGFloat)height {
    return _pbHeight;
}

@end
