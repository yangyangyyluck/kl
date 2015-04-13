//
//  UIImage+Additions.m
//  TGod
//
//  Created by yangyang on 14/12/19.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#import "UIImage+YOSAdditions.h"

@implementation UIImage (YOSAdditions)

+ (UIImage *)yos_imageWithColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

@end
