//
//  YOSUserSendCodeRequest.h
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserSendCodeRequest : YOSBaseRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber;

@end
