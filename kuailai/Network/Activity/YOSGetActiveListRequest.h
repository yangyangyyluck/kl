//
//  YOSGetActiveList.h
//  kuailai
//
//  Created by yangyang on 15/6/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSGetActiveListRequest : YOSBaseRequest

- (instancetype)initWithCity:(YOSCityType)city page:(NSUInteger)page start_time:(NSUInteger)time type:(NSUInteger)type;

@end
