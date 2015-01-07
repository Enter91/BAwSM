//
//  RecordedVideosTableViewCell.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordedVideosTableViewCellDelegate <NSObject>

- (void)wantsPlayMovieWithAssetURL:(NSURL *)assetURL;
- (void)wantsShowMapWithRouteArray:(NSArray *)routeArray andDateString:(NSString *)date;

@end

@interface RecordedVideosTableViewCell : UITableViewCell

/**
 *  @Author Michał Czwarnowski
 *
 *  Tytuł wyświetlany w pojedynczej komórce tabeli
 */
@property (strong, nonatomic) UILabel *title;

/**
 *  @Author Michał Czwarnowski
 *
 *  Data nagrania wyświetlana w komórce tabeli
 */
@property (strong, nonatomic) UILabel *date;

/**
 *  @Author Michał Czwarnowski
 *
 *  Miniaturka nagranego filmu wyświetlana w komórce tabeli
 */
@property (strong, nonatomic) UIImageView *movieThumbnail;

/**
 *  @Author Michał Czwarnowski
 *
 *  Przycisk mapy otwierający widok trasy zapisanej dla danego nagrania
 */
@property (strong, nonatomic) UIButton *mapsButton;

/**
 *  @Author Michał Czwarnowski
 *
 *  Asset URL nagranego filmu
 */
@property (strong, nonatomic) NSURL *outputFileURL;

@property (strong, nonatomic) NSArray *routeArray;

- (void)setTitleText:(NSString *)titleText dateText:(NSString *)dateText movieThumbnail:(UIImage *)movieThumbnail route:(NSArray *)route andAssetURL:(NSURL *)assetURL;
- (void)updateAllFrames;

@property (weak, nonatomic) id delegate;

@end
