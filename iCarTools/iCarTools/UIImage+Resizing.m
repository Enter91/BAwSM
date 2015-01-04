//
//  UIImage+Resizing.m
//  iCarTools
//
//  Created by Michał Czwarnowski on 04.01.2015.
//  Copyright (c) 2015 Michał Czwarnowski. All rights reserved.
//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

- (UIImage *)scaleToSize:(CGSize)targetSize {
    CGFloat scaleFactor = 1.0;
    
    if (self.size.width > targetSize.width || self.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / self.size.width)) > (targetSize.height / self.size.height)))
            scaleFactor = targetSize.height / self.size.height;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect rect = CGRectMake((targetSize.width - self.size.width * scaleFactor) / 2,
                             (targetSize.height -  self.size.height * scaleFactor) / 2,
                             self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    [self drawInRect:rect];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
