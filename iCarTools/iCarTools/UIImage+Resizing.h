//
//  UIImage+Resizing.h
//  iCarTools
//
//  Created by Michał Czwarnowski on 04.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Kategoria rozszerzająca klasę UIImage o skalowanie obrazu do dowolnego rozmiaru
 */
@interface UIImage (Resizing)

/*!
 *  @Author Michał Czwarnowski
 *
 *  @brief  Skaluje obraz do dowolnego rozmiaru podanego jako parametr. W przypadku gdy docelowe aspect ratio jest inne niż oryginalne obraz jest przycinany.
 *
 *  @param targetSize Docelowy rozmiar obrazu
 *
 *  @return Przeskalowany obraz
 */
- (UIImage *)scaleToSize:(CGSize)targetSize;

@end
