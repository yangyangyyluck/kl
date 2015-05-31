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

@property (nonatomic, copy) voidBlock vBlock;

- (instancetype)initWithActivityFatherTypeModels:(NSArray *)activityFatherTypeModels;

- (CGFloat)currentHeight;

- (NSString *)type;

- (NSString *)childType;

@end
