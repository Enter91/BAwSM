//
//  MyCustomAnnotation.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 15.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSubtitle Location:(CLLocationCoordinate2D)location Company:(NSString *)newCompany {
    
    self = [super init];
    
    if(self) {
        _title = newTitle;
        _subtitle = newSubtitle;
        _coordinate = location;
        _company = newCompany;
    }
    
    return self;
}

/**
 *  @Author Damian Klimaszewski
 *
 *  Set custom annotation view
 */
- (MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:_company];
                                    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    NSString *name = _company;
    annotationView.image = [UIImage imageNamed:name];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [leftButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    annotationView.leftCalloutAccessoryView = leftButton;
    
    return annotationView;
}

@end
