//
//  RecordedVideosTableViewCell.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordedVideosTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIImageView *movieThumbnail;
@property (strong, nonatomic) UIButton *mapsButton;

@property (strong, nonatomic) NSURL *outputFileURL;

@property (strong, nonatomic) NSArray *routeArray;
@end