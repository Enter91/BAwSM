//
//  RecordedVideosTableViewCell.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "RecordedVideosTableViewCell.h"

static NSString * const DIN_PRO_LIGHT = @"DINPro-Light";

@implementation RecordedVideosTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _movieThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80.0, 80.0)];
        [_movieThumbnail setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_movieThumbnail];
        
        _mapsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapsButton setFrame:CGRectMake(self.frame.size.width - 45, 5, 40, 40)];
        [_mapsButton setImage:[UIImage imageNamed:@"Maps-icon"] forState:UIControlStateNormal];
        [_mapsButton addTarget:self action:@selector(showMapWithRoute) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapsButton];
        
        _date = [[UILabel alloc] initWithFrame:CGRectMake(_movieThumbnail.frame.size.width + 5, self.frame.size.height - 15.0, self.frame.size.width - _movieThumbnail.frame.size.width - 10, 10.0)];
        [_date setFont:[UIFont systemFontOfSize:10.0]];
        [_date setLineBreakMode:NSLineBreakByTruncatingTail];
        [_date setNumberOfLines:1];
        [self addSubview:_date];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(_movieThumbnail.frame.size.width + 5, 5.0, self.frame.size.width - _movieThumbnail.frame.size.width - 10, self.frame.size.height - _date.frame.size.height - 10)];
        [_title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [_title setLineBreakMode:NSLineBreakByTruncatingTail];
        [_title setNumberOfLines:1];
        [self addSubview:_title];
    }
    
    return self;
    
}

- (void)prepareForReuse {
    _movieThumbnail.image = nil;
    _title.text = @"";
    _date.text = @"";
    _outputFileURL = nil;
    _routeArray = nil;
}

- (void)setTitleText:(NSString *)titleText dateText:(NSString *)dateText movieThumbnail:(UIImage *)movieThumbnail route:(NSArray *)route andAssetURL:(NSURL *)assetURL {
    
    [_title setText:titleText];
    [_date setText:dateText];
    [_movieThumbnail setImage:movieThumbnail];
    _routeArray = [NSArray arrayWithArray:route];
    _outputFileURL = assetURL;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showMapWithRoute {
    
}

@end
