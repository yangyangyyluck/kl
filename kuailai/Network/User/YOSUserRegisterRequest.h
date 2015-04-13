//
//  YOSUserRegisterRequest.h
//  kuailai
//
//  Created by yangyang on 15/4/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserRegisterRequest : YOSBaseRequest

- (instancetype)initWithUserName:(NSString *)username ID:(NSString *)ID password1:(NSString *)password1 password2:(NSString *)password2;

@end
