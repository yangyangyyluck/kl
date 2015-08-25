//
//  YOSUserInfoViewController.h
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseViewController.h"

@class YOSUserInfoModel;

@interface YOSUserInfoViewController : YOSBaseViewController

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@property (nonatomic, copy) NSString *hx_user;

@property (nonatomic, assign) BOOL hideButtons;

@end
