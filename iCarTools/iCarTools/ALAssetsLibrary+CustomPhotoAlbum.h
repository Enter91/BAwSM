//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Completion Block uruchamiany po udanym zapisie pliku
 *
 *  @param asset Asset pliku wideo lub zdjęcia
 */
typedef void(^SaveImageCompletion)(ALAsset *asset);

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Completion Block uruchamiany w przypadku błędu zapisu
 *
 *  @param error Błąd
 */
typedef void(^SaveImageError)(NSError* error);

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Kategoria rozszerzająca klasę ALAssetsLibrary o możliwość zapisu pliku wideo lub zdjęcia do katalogu o dowolnej nazwie
 */
@interface ALAssetsLibrary(CustomPhotoAlbum)

/*!
 *  @author Michał Czwarnowski
 *
 *  @brief  Metoda umożliwia zapis zdjęcia do Rolki oraz do dowolnego folderu
 *
 *  @param image                Zdjęcie do zapisania
 *  @param albumName            Nazwa customego albumu
 *  @param completionBlock      Blok uruchamiany po udanym zapisie
 *  @param completionBlockError Blok uruchamiany w przypadku błędu
 */
-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock andErrorBlock:(SaveImageError)completionBlockError;

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Metoda umożliwia zapis pliku wideo do Rolki oraz do dowolnego folderu
 *
 *  @param assetURL             URL assetu
 *  @param albumName            Nazwa customowego albumu
 *  @param completionBlock      Blok uruchamiany po udanym zapisie
 *  @param completionBlockError Blok uruchamiany w przypadku błędu
 */
-(void)saveVideo:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock andErrorBlock:(SaveImageError)completionBlockError;;
@end