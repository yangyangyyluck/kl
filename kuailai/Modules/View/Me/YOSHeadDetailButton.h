//
//  YOSHeadDetailButton.h
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YOSUserInfoModel;
@interface YOSHeadDetailButton : UIButton

@property (nonatomic, assign) BOOL showRightAccessory;

- (instancetype)initWithUserInfoModel:(YOSUserInfoModel *)userInfoModel;

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@end
