//
//  YOSUserGetMyCollectListRequest.h
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserGetMyCollectListRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page;

@end
