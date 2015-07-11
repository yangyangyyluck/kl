//
//  YOSTapDeleteView.h
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSTagModel;

@interface YOSTapDeleteView : UIView

@property (nonatomic, assign, readonly) CGSize yos_contentSize;

- (instancetype)initWithTagModel:(YOSTagModel *)tagModel;

@end
