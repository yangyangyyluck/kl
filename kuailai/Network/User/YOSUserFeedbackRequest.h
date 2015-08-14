//
//  YOSUserFeedbackRequest.h
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserFeedbackRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid demand:(NSString *)demand;

@end
