//
//  YOSAccessoryView.h
//  kuailai
//
//  Created by yangyang on 15/4/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YOSAccessoryViewPosition) {
    YOSAccessoryViewPositionLeft    = 1 << 0,
    YOSAccessoryViewPositionRight   = 1 << 1,
};

@interface YOSAccessoryView : UIView

- (instancetype)initWithDefaultPlaceBlock:(void(^)(void))defaultPlaceBlock;

- (void)setupDefaultPlaceBlock:(void (^)(void))defaultPlaceBlock;

- (UIButton *)buttonWithTitle:(NSString *)title target:(__weak id)target method:(SEL)sel position:(YOSAccessoryViewPosition)position;

@end
