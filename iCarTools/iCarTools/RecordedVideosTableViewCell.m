//
//  RecordedVideosTableViewCell.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "RecordedVideosTableViewCell.h"
@import MediaPlayer;
@import AVFoundation;

static NSString * const DIN_PRO_LIGHT = @"DINPro-Light";
static NSString * const DIN_PRO_BOLD = @"DINPro-Bold";

@interface RecordedVideosTableViewCell ()

@property (strong, nonatomic) MPMoviePlayerController *player;

@end

@implementation RecordedVideosTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 80);
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setFrame:CGRectMake(0, 0, 80, 80)];
        [playButton addTarget:self action:@selector(showVideo) forControlEvents:UIControlEventTouchUpInside];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        _movieThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80.0, 80.0)];
        [_movieThumbnail setContentMode:UIViewContentModeScaleAspectFill];
        [_movieThumbnail setClipsToBounds:YES];
        [self addSubview:_movieThumbnail];
        [self addSubview:playButton];
        playButton = nil;
        
        _mapsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapsButton setFrame:CGRectMake(self.frame.size.width - 45, 20, 40, 40)];
        [_mapsButton setImage:[UIImage imageNamed:@"Maps-icon"] forState:UIControlStateNormal];
        [_mapsButton addTarget:self action:@selector(showMapWithRoute) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapsButton];
        
        _date = [[UILabel alloc] initWithFrame:CGRectMake(_movieThumbnail.frame.size.width + 5, self.frame.size.height - 20.0, self.frame.size.width - _movieThumbnail.frame.size.width - _mapsButton.frame.size.width - 15, 15.0)];
        [_date setFont:[UIFont fontWithName:DIN_PRO_LIGHT size:12.0]];
        [_date setLineBreakMode:NSLineBreakByTruncatingTail];
        [_date setNumberOfLines:1];
        [self addSubview:_date];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(_movieThumbnail.frame.size.width + 5, 5.0, self.frame.size.width - _movieThumbnail.frame.size.width - _mapsButton.frame.size.width - 15, self.frame.size.height - _date.frame.size.height - 10)];
        [_title setFont:[UIFont fontWithName:DIN_PRO_BOLD size:20.0]];
        [_title setLineBreakMode:NSLineBreakByTruncatingTail];
        [_title setNumberOfLines:1];
        [self addSubview:_title];
    }
    
    return self;
    
}

- (void)updateAllFrames {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 80);
    [_movieThumbnail setFrame:CGRectMake(0, 0, 80.0, 80.0)];
    [_date setFrame:CGRectMake(_movieThumbnail.frame.size.width + 5, self.frame.size.height - 20.0, self.frame.size.width - _movieThumbnail.frame.size.width - _mapsButton.frame.size.width - 15, 15.0)];
    [_title setFrame:CGRectMake(_movieThumbnail.frame.size.width + 5, 5.0, self.frame.size.width - _movieThumbnail.frame.size.width - _mapsButton.frame.size.width - 15, self.frame.size.height - _date.frame.size.height - 10)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_mapsButton setFrame:CGRectMake(self.frame.size.width - 45, 5, 40, 40)];
    }];
}

- (void)prepareForReuse {
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    _movieThumbnail.image = nil;
    _title.text = @"";
    _date.text = @"";
    _outputFileURL = nil;
    _routeArray = nil;
}

- (void)setTitleText:(NSString *)titleText dateText:(NSString *)dateText movieThumbnail:(UIImage *)movieThumbnail route:(NSArray *)route andAssetURL:(NSURL *)assetURL {
    
    [_title setText:titleText];
    [_date setText:dateText];
    
    _routeArray = [NSArray arrayWithArray:route];
    _outputFileURL = assetURL;
    
    if (movieThumbnail != nil) {
        [_movieThumbnail setImage:movieThumbnail];
    } else {
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:assetURL options:nil];
        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generate.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMake(1, 120);
        CGImageRef thumbImg = [generate copyCGImageAtTime:time actualTime:NULL error:nil];
        _movieThumbnail.image = [UIImage imageWithCGImage:thumbImg];
        thumbImg = nil;
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showMapWithRoute {
    [_delegate wantsShowMapWithRouteArray:[_routeArray copy]];
}

- (void)showVideo {
    [_delegate wantsPlayMovieWithAssetURL:_outputFileURL];
}

@end
