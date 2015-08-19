//
//  YOSHomeSwitchView.h
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSHomeSwitchView;
@protocol YOSHomeSwitchViewDelegate <NSObject>

- (void)homeSwitchView:(YOSHomeSwitchView *)homeSwitchView selectedIndex:(NSUInteger)selectedIndex selectedSubIndex:(NSUInteger)selectedSubIndex;

@end

@interface YOSHomeSwitchView : UIView

@property (nonatomic, weak) id <YOSHomeSwitchViewDelegate>delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) NSUInteger selectedTime;

@property (nonatomic, assign) NSUInteger selectedType;

@property (nonatomic, assign) NSUInteger selectedPosition;

@end
