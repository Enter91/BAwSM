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

/*!
 *  @author Damian Klimaszewski
 *
 *  Współrzędne stacji
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 *  @author Damian Klimaszewski
 *
 *  Własna annotacja z danymi z bazy
 */
- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSubtitle Location:(CLLocationCoordinate2D)location Company:(NSString *)newCompany;
- (MKAnnotationView *) annotationView;

/*!
 *  @author Damian Klimaszewski
 *
 *  Tytuł annotacji
 */
@property (nonatomic, copy) NSString *title;

/*!
 *  @author Damian Klimaszewski
 *
 *  Podtytuł annotacji
 */
@property (nonatomic, copy) NSString *subtitle;

/*!
 *  @author Damian Klimaszewski
 *
 *  Nazwa koncernu paliwowego
 */
@property (nonatomic, copy) NSString *company;

@end
