//
//  YOSInterestGetActiveListRequest.h
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSInterestGetActiveListRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page;

@end
