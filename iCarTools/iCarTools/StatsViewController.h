//
//  StatsViewController.h
//  iCarTools
//
//  Created by Damian Klimaszewski on 12.11.2014.
//  Copyright (c) 2014 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSUtilities.h"

@interface StatsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, assign) id delegate;

@end
