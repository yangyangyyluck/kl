//
//  YOSUserAuditRegisterRequest.h
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseRequest.h"

typedef NS_ENUM(NSUInteger, YOSUserAuditRegisterType) {
    YOSUserAuditRegisterTypePass = 1,
    YOSUserAuditRegisterTypeRefuse,
};

@interface YOSUserAuditRegisterRequest : YOSBaseRequest

- (instancetype)initWithID:(NSString *)ID andStatus:(YOSUserAuditRegisterType)status;

@end
