//
//  MyCustomAnnotation.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 15.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GPSUtilities.h"

@interface MyCustomAnnotation : MKAnnotationView <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSubtitle Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *) annotationView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
