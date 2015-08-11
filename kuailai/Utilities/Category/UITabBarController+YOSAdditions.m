//
//  UITabBarController+YOSAdditions.m
//  kuailai
//
//  Created by yangyang on 15/8/11.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "UITabBarController+YOSAdditions.h"
#import <objc/runtime.h>

@interface UITabBarController ()

@property (nonatomic, strong) UIImageView *redDotImageView;

@end

@implementation UITabBarController (YOSAdditions)

#pragma mark - red dot

- (void)showRedDotWithButtonAtIndex:(NSUInteger)index {
    self.redDotImageView.hidden = NO;
    
    CGFloat tabBarBtnWidth = YOSScreenWidth / 4;
    
    CGFloat x = (index + 0.5) * tabBarBtnWidth + 20;
    self.redDotImageView.frame = CGRectMake(x, 10, 8, 8);
    
    [self.tabBar bringSubviewToFront:self.redDotImageView];
}

- (void)hideRedDotWithButtonAtIndex:(NSUInteger)index {
    self.redDotImageView.hidden = YES;
}

#pragma mark - getter & setter

- (UIImageView *)redDotImageView {
    UIImageView *redDotImageView = objc_getAssociatedObject(self, @"redDotImageView");
    
    if (!redDotImageView) {
        redDotImageView = [UIImageView new];
        [self.tabBar addSubview:redDotImageView];
        redDotImageView.image = [UIImage imageNamed:@"消息数字红点"];
        self.redDotImageView = redDotImageView;
    }
    
    return redDotImageView;
}

- (void)setRedDotImageView:(UIImageView *)redDotImageView {
    objc_setAssociatedObject(self, @"redDotImageView",redDotImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
