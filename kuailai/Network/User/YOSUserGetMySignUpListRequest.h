//
//  YOSUserGetMySignUpListRequest.h
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserGetMySignUpListRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page;

@end
