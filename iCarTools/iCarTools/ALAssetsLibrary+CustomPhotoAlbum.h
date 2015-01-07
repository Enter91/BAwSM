//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Marin Todorov on 10/26/11.
//  Copyright (c) 2011 Marin Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

typedef void(^SaveImageCompletion)(ALAsset *asset);
typedef void(^SaveImageError)(NSError* error);

@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock andErrorBlock:(SaveImageError)completionBlockError;;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock andErrorBlock:(SaveImageError)completionBlockError;


/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Metoda umożliwia zapis pliku wideo do Rolki oraz do dowolnego folderu
 *
 *  @param assetURL             URL assetu
 *  @param albumName            Nazwa customowego katalogu
 *  @param completionBlock      Blok uruchamiany po udanym zapisie
 *  @param completionBlockError Blok uruchamiany w przypadku błędu
 */
-(void)saveVideo:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock andErrorBlock:(SaveImageError)completionBlockError;;
@end