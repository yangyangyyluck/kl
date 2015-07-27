//
//  YOSInterestGetUserListRequest.h
//  kuailai
//
//  Created by yangyang on 15/7/27.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSInterestGetUserListRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page;

@end
