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

- (void)awakeFromNib {
    
    self.backgroundImage = [UIImage yos_imageWithColor:YOSRGB(61, 57, 56) size:CGSizeMake((YOSScreenWidth / 4), 49)];

    self.selectionIndicatorImage = [UIImage yos_imageWithColor:YOSRGB(46, 43, 42) size:CGSizeMake((YOSScreenWidth / 4), 49)];
    
}

@end
