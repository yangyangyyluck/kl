//
//  YOSUserAddTagRequest.h
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

@interface YOSUserAddTagRequest : YOSBaseRequest

- (instancetype)initWithUid:(NSString *)uid tagString:(NSString *)string;

@end
