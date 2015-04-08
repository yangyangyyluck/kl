//
//  YOSTabBarItem.m
//  kuailai
//
//  Created by yangyang on 15/3/17.
//  Copyright (c) 2015年 isasa. All rights reserved.
//

#import "YOSTabBarItem.h"

@implementation YOSTabBarItem

- (void)setSelectedImage:(UIImage *)selectedImage {
    UIImage *img = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [super setSelectedImage:img];
}

@end
