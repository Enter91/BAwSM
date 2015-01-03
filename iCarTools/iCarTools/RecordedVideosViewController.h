//
//  RecordedVideosViewController.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordedVideosTableViewCell.h"
@import AssetsLibrary;

@interface RecordedVideosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *videosTableView;
@property (strong, nonatomic) NSMutableArray *videosArray;

@end
