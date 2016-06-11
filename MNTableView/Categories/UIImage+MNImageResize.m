//
//  UIImage+MNImageResize.m
//  MNTableView
//
//  Created by Ali, Muhammad on 09/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import "UIImage+MNImageResize.h"

@implementation UIImage (MNImageResize)

+ (UIImage*)resizeImage:(UIImage*)image constraintToSize:(CGSize)maxSize {
    UIImage *resizedImage;
    CGSize imageSize = image.size;
    CGFloat heightScale = [[self class] scaleWithActualValue:imageSize.height maxValue:maxSize.height];
    CGFloat widthScale = [[self class] scaleWithActualValue:imageSize.width maxValue:maxSize.width];
    CGFloat scale = (heightScale > widthScale)?heightScale:widthScale;
    
    CGSize destinationImageSize = CGSizeMake(imageSize.width*scale, imageSize.height*scale);
    UIGraphicsBeginImageContext(destinationImageSize);
    [image drawInRect:CGRectMake(0, 0, destinationImageSize.width, destinationImageSize.height)];
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

+ (CGFloat)scaleWithActualValue:(CGFloat)actualValue maxValue:(CGFloat)maxValue {
    if (actualValue > maxValue) {
        return maxValue/actualValue;
    }
    return actualValue/maxValue;
}
@end
