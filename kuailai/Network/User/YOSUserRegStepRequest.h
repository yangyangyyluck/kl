//
//  YOSUserRegStepRequest.h
//  kuailai
//
//  Created by yangyang on 15/4/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserRegStepRequest : YOSBaseRequest

- (instancetype)initWithUserName:(NSString *)username validateCode:(NSString *)code;

@end
