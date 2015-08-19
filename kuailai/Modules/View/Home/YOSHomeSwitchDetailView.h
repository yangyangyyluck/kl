//
//  YOSHomeSwitchDetailView.h
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSHomeSwitchDetailView;
@protocol YOSHomeSwitchDetailViewDelegate <NSObject>

- (void)homeSwitchDetailView:(YOSHomeSwitchDetailView *)detailView index:(NSUInteger)index selected:(BOOL)selected;

@end

@interface YOSHomeSwitchDetailView : UIView

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, copy) voidBlock hudBlock;

@property (nonatomic, weak) id <YOSHomeSwitchDetailViewDelegate>delegate;

- (instancetype)initWithTitles:(NSArray *)titles btnCountsPerRow:(NSUInteger)btnCountsPerRow superView:(UIView *)superView;

- (void)showWhiteWithAnimation;
- (void)hideWhiteWithAnimation;
- (void)showDetailView;
- (void)hideDetailView;

@end
