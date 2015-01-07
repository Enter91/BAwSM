//
//  FixedCompassLayout.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 25.11.2014.
//  Copyright (c) 2014 Damian Klimaszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*!
 * @author Damian Klimaszewski
 * @discussion Klasa poprawki położenia kompasu
 */
@interface FixedCompassLayout : NSObject <UILayoutSupport>

/*!
 *  @author Damian Klimaszewski
 * @discussion Zmienia pozycję kompasu na mapie
 */
@property (nonatomic) CGFloat pbLength;

/*!
 *  @author Damian Klimaszewski
 *  @discussion inicjacja kompasu ze zmianą położenia
 */
- (id)initWithLength:(CGFloat)length;

@end
