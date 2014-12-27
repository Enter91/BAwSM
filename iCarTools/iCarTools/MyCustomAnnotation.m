//
//  MyCustomAnnotation.m
//  iCarTools
//
//  Created by Damian Klimaszewski on 15.12.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

- (id)initWithTitle:(NSString *)newTitle Subtitle:(NSString *)newSubtitle Location:(CLLocationCoordinate2D)location {
    
    self = [super init];
    
    if(self) {
        _title = newTitle;
        _subtitle = newSubtitle;
        _coordinate = location;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
                                    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"gas"];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(stationView) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    
    return annotationView;
}

- (void)stationView {
   
}

@end
