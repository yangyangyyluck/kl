//
//  YOSActivityTypeView.h
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YOSActivityFatherTypeModel;

@interface YOSActivityTypeView : UIView

- (instancetype)initWithActivityFatherTypeModels:(NSArray *)activityFatherTypeModels;

- (CGFloat)currentHeight;

@end
