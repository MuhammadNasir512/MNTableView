//
//  UIImage+MNImageResize.h
//  MNTableView
//
//  Created by Ali, Muhammad on 09/06/2016.
//  Copyright © 2016 Ali, Muhammad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MNImageResize)
+ (UIImage*)resizeImage:(UIImage*)image constraintToSize:(CGSize)maxSize;
@end
