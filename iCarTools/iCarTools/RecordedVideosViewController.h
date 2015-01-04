//
//  RecordedVideosViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordedVideosTableViewCell.h"
#import <SWRevealViewController.h>
@import AVFoundation;
@import MediaPlayer;
@import AssetsLibrary;
#import "RouteViewController.h"

@interface RecordedVideosViewController : UIViewController <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *videosTableView;
@property (strong, nonatomic) NSMutableArray *videosArray;

@property (nonatomic) BOOL wantsCustomAnimation;
@property (nonatomic, weak) UIViewController *parentView;
@end
