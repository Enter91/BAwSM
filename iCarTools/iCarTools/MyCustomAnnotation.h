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
 *
 *  @brief  Własna annotacja z danymi z bazy
 *
 *  @param newTitle    Tytuł annotacji z nazwą stacji
 *  @param newSubtitle Podtytuł annotacji z adresem stacji
 *  @param location    Lokalizacja stacji
 *  @param newCompany  Nazwa koncernu paliwowego
 *
 *  @return Obiekt typu MyCustomAnnotation
 */
- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSubtitle Location:(CLLocationCoordinate2D)location Company:(NSString *)newCompany;

/*!
 *  @author Damian Klimaszewski
 *
 *  @brief  Tworzy annotację i zwraca jej widok.
 *
 *  @return Widok annotacji
 */
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
