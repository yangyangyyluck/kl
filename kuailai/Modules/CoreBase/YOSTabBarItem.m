//
//  YOSTabBarItem.m
//  kuailai
//
//  Created by yangyang on 15/3/17.
//  Copyright (c) 2015年 isasa. All rights reserved.
//

#import "YOSTabBarItem.h"

@implementation YOSTabBarItem

+ (void)initialize {
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       YOSRGB(139, 138, 138),
                                                       NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor orangeColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    UIImage *img = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [super setSelectedImage:img];
}

@end
