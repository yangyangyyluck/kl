//
//  YOSUserInfoViewController.h
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseViewController.h"

@class YOSUserInfoModel;

@interface YOSAddRequestViewController : YOSBaseViewController

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@property (nonatomic, assign) BOOL hideButtons;

@end
