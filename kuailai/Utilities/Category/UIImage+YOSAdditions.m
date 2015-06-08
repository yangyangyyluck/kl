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

+ (UIImage *)yos_imageCutWithView:(UIView *)view {
    
    // open context
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    // get this context
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // view's layer
    [view.layer renderInContext:ref];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage *)yos_imageCutWithView:(UIView *)view atRect:(CGRect)rect {
    
    UIImage *image = [self yos_imageCutWithView:view];
    
    UIImage *resultImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x * image.scale, rect.origin.y * image.scale, rect.size.width * image.scale, rect.size.height * image.scale))];
    
    return resultImage;
}

@end
