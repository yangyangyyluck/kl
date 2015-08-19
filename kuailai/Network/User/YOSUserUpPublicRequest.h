//
//  YOSUserUpPublicRequest.h
//  kuailai
//
//  Created by yangyang on 15/8/17.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserUpPublicRequest : YOSBaseRequest


/** 1 接受 2 不接受 */

- (instancetype)initWithUid:(NSString *)uid isPublic:(NSString *)isPublic;

@end
