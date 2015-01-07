//
//  RouteViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 04.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SWRevealViewController.h>

@interface RouteViewController : UIViewController <UINavigationControllerDelegate, MKMapViewDelegate>

/**
 *  @Author Michał Czwarnowski
 *
 *  Funkcja inicjalizująca kontroler widoku Route.
 *
 *  @param points     Tablica z kolejnymi lokalizacjami, które wyświetlone będą na mapie
 *  @param dateString Data nagrania dopisywana w tekście dołączonym do udostępnianego widoku trasy
 *
 *  @return Obiekt klasy RouteViewController
 */
- (instancetype)initWithRoutePointsArray:(NSArray *)points andDateString:(NSString *)dateString;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

/**
 *  @Author Michał Czwarnowski
 *
 *  Widok, z którego został uruchomiony RecorderViewController. Wykorzystywany do powrotu do poprzedniego kontrolera.
 */
@property (nonatomic, strong) UIViewController *parentView;

@end
