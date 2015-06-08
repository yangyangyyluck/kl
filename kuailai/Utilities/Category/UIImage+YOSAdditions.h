//
//  UIImage+Additions.h
//  TGod
//
//  Created by yangyang on 14/12/19.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YOSAdditions)

+ (UIImage *)yos_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  截图
 *
 *  @param view 要截图的view
 *
 *  @return UIImage
 */
+ (UIImage *)yos_imageCutWithView:(UIView *)view;

+ (UIImage *)yos_imageCutWithView:(UIView *)view atRect:(CGRect)rect;

@end
