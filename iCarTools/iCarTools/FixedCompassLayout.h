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

/**
 *  @author Damian Klimaszewski
 *
 *  Zmienia pozycję kompasu na mapie
 */
@property (nonatomic) CGFloat pbLength;

/**
 *  @author Damian Klimaszewski
 *
 *  inicjacja kompasu ze zmianą położenia 
 */
- (id)initWithLength:(CGFloat)length;

@end
