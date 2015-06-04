//
//  YOSUserLoginRequest.h
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserLoginRequest : YOSBaseRequest

- (instancetype)initWithUserName:(NSString *)username pwd:(NSString *)pwd models:(NSString *)models;

@end
