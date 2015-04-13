//
//  YOSTabBar.m
//  kuailai
//
//  Created by yangyang on 15/3/16.
//  Copyright (c) 2015年 isasa. All rights reserved.
//

#import "YOSTabBar.h"
#import "UIImage+YOSAdditions.h"

@implementation YOSTabBar {
    
}

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

- (void)awakeFromNib {
    
    self.backgroundImage = [UIImage yos_imageWithColor:YOSRGB(61, 57, 56) size:CGSizeMake(80, 49)];
    
    self.selectionIndicatorImage = [UIImage yos_imageWithColor:YOSRGB(46, 43, 42) size:CGSizeMake(80, 49)];
    
}

@end
