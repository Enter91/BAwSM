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

/*!
 * @author Damian Klimaszewski
 * @discussion Klasa własnych annotacji
 */
@interface MyCustomAnnotation : MKAnnotationView <MKAnnotation>

/*!
 *  @author Damian Klimaszewski
 *  @discussion Współrzędne stacji
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Własna annotacja z danymi z bazy
 */
- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSubtitle Location:(CLLocationCoordinate2D)location Company:(NSString *)newCompany;
- (MKAnnotationView *) annotationView;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Tytuł annotacji
 */
@property (nonatomic, copy) NSString *title;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Podtytuł annotacji
 */
@property (nonatomic, copy) NSString *subtitle;

/*!
 *  @author Damian Klimaszewski
 *  @discussion Nazwa koncernu paliwowego
 */
@property (nonatomic, copy) NSString *company;

@end
