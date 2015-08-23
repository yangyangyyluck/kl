//
//  YOSUserUppwdByUnameRequest.h
//  kuailai
//
//  Created by yangyang on 15/8/23.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserUppwdByUnameRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid code:(NSString *)code pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2;

@end
