//
//  YOSUserConfirmRegisterRequest.h
//  kuailai
//
//  Created by yangyang on 15/7/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserConfirmRegisterRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid aid:(NSString *)aid;

@end
