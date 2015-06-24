//
//  YOSUserUpdateUserRequest.h
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@class YOSUpdateUserInfoModel;

@interface YOSUserUpdateUserRequest : YOSBaseRequest

- (instancetype)initWithUpdateUserInfoModel:(YOSUpdateUserInfoModel *)model;

@end
