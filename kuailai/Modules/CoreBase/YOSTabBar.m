//
//  YOSTabBar.m
//  kuailai
//
//  Created by yangyang on 15/3/16.
//  Copyright (c) 2015年 isasa. All rights reserved.
//

#import "YOSTabBar.h"
#import "UIImage+YOSAdditions.h"

@interface YOSTabBar ()

@property (nonatomic, strong) UIImageView *redDotImageView;

@end

@implementation YOSTabBar {
    
}

- (void)awakeFromNib {
    
    self.backgroundImage = [UIImage yos_imageWithColor:YOSRGB(61, 57, 56) size:CGSizeMake((YOSScreenWidth / 4), 49)];

    self.selectionIndicatorImage = [UIImage yos_imageWithColor:YOSRGB(46, 43, 42) size:CGSizeMake((YOSScreenWidth / 4), 49)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRedDot:) name:YOSNotificationShowRedDot object:nil];
    
    self.barTintColor = YOSRGB(61, 57, 56);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showRedDotWithButtonAtIndex:(NSUInteger)index {
    self.redDotImageView.hidden = NO;
    
    CGFloat tabBarBtnWidth = YOSScreenWidth / 4;
    
    CGFloat x = (index + 0.5) * tabBarBtnWidth + 20;
    self.redDotImageView.frame = CGRectMake(x, 10, 8, 8);
    
    [self bringSubviewToFront:self.redDotImageView];
}

- (void)hideRedDot {
    self.redDotImageView.hidden = YES;
}

#pragma mark - override system methods

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    
    __block NSUInteger currentSelectedIndex = 0;
    
    [self.items enumerateObjectsUsingBlock:^(UITabBarItem *obj, NSUInteger idx, BOOL *stop) {
        if ([self.selectedItem isEqual:obj]) {
            currentSelectedIndex = idx;
        }
    }];
    
    NSUInteger index = 1;
    if (currentSelectedIndex == index) {
        [self hideRedDot];
    }
    
    [super setSelectedItem:selectedItem];
    
}

#pragma mark - deal notification

- (void)showRedDot:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    
    NSUInteger index = [userInfo[@"index"] integerValue];
    
    __block NSUInteger currentSelectedIndex = 0;
    
    [self.items enumerateObjectsUsingBlock:^(UITabBarItem *obj, NSUInteger idx, BOOL *stop) {
        if ([self.selectedItem isEqual:obj]) {
            currentSelectedIndex = idx;
        }
    }];
    
    if (currentSelectedIndex != index) {
        [self showRedDotWithButtonAtIndex:index];
    }
    
}

#pragma mark - getter & setter

- (UIImageView *)redDotImageView {
    if (!_redDotImageView) {
        _redDotImageView = [UIImageView new];
        _redDotImageView.image = [UIImage imageNamed:@"消息数字红点"];
        [self addSubview:_redDotImageView];
    }
    
    return _redDotImageView;
}


@end
