//
//  FixedCompassLayout.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 25.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "FixedCompassLayout.h"

@implementation FixedCompassLayout

- (id)initWithLength:(CGFloat)length {
    self = [super init];
    if (self) {
        _pbLength = length;
    }
    return self;
}

- (CGFloat)length {
    return _pbLength;
}

@end
