//
//  YOSUserUppwdRequest.h
//  kuailai
//
//  Created by yangyang on 15/8/23.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserUppwdRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid pwd:(NSString *)pwd pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2;

@end
