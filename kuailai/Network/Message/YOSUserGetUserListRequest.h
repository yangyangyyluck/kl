//
//  YOSUserGetUserListRequest.h
//  kuailai
//
//  Created by yangyang on 15/7/27.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserGetUserListRequest : YOSBaseRequest

- (instancetype)initWithName:(NSString *)name andPage:(NSString *)page;

@end
