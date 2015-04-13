//
//  YOSAccessoryView.h
//  kuailai
//
//  Created by yangyang on 15/4/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YOSAccessoryViewPosition) {
    YOSAccessoryViewPositionLeft = 1,
    YOSAccessoryViewPositionRight
};

@interface YOSAccessoryView : UIView

- (instancetype)initWithTitle:(NSString *)title target:(id)target method:(SEL)sel position:(YOSAccessoryViewPosition)position;

- (void)setupTitle:(NSString *)title target:(id)target method:(SEL)sel;

- (void)setupDefaultPlaceBlock:(void (^)(void))defaultPlaceBlock;

@end
