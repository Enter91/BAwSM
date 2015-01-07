//
//  RecordedVideosTableViewCell.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 03.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordedVideosTableViewCellDelegate <NSObject>

/*!
 *  @Author Michał Czwarnowski
 *
 *  Uruchamia żądanie odtwarzania filmu przypisanego komórce
 *
 *  @param assetURL URL assetu
 */
- (void)wantsPlayMovieWithAssetURL:(NSURL *)assetURL;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Uruchamia żądanie wyświetlenia mapy z trasą nagrania
 *
 *  @param routeArray Tablica zawierające kolejne punkty lokalizacyjne zapisywane podczas nagrywania
 *  @param date       Data nagrania
 */
- (void)wantsShowMapWithRouteArray:(NSArray *)routeArray andDateString:(NSString *)date;

@end

@interface RecordedVideosTableViewCell : UITableViewCell

/*!
 *  @Author Michał Czwarnowski
 *
 *  Tytuł wyświetlany w pojedynczej komórce tabeli
 */
@property (strong, nonatomic) UILabel *title;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Data nagrania wyświetlana w komórce tabeli
 */
@property (strong, nonatomic) UILabel *date;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Miniaturka nagranego filmu wyświetlana w komórce tabeli
 */
@property (strong, nonatomic) UIImageView *movieThumbnail;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Przycisk mapy otwierający widok trasy zapisanej dla danego nagrania
 */
@property (strong, nonatomic) UIButton *mapsButton;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Asset URL nagranego filmu
 */
@property (strong, nonatomic) NSURL *outputFileURL;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Ustawia wszystkie zmienne w komórce
 *
 *  @param titleText      Tytuł wyświetlany w komórce tabeli
 *  @param dateText       Data nagrania
 *  @param movieThumbnail Miniaturka nagranego filmu
 *  @param route          Tablica z kolejnymi lokalizacjami zapisywanymi w trakcie nagrywania
 *  @param assetURL       URL assetu wideo
 */
- (void)setTitleText:(NSString *)titleText dateText:(NSString *)dateText movieThumbnail:(UIImage *)movieThumbnail route:(NSArray *)route andAssetURL:(NSURL *)assetURL;

/*!
 *  @Author Michał Czwarnowski
 *
 *  Aktualizuje położenie wszystkich elementów w komórce dla trybu landscape i portrait
 */
- (void)updateAllFrames;

/*!
 * @author Michał Czwarnowski
 * @discussion Delegat klasy RecordedVideosTableViewCell
 */
@property (weak, nonatomic) id delegate;

@end
