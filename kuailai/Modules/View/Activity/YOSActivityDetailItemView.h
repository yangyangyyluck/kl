//
//  YOSActivityDetailItemView.h
//  kuailai
//
//  Created by yangyang on 15/6/11.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSActivityDetailItemView : UIView

@property (nonatomic, assign, readonly) CGFloat itemHeight;

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title;

@property (nonatomic, assign) BOOL showBottomLine;

@end
