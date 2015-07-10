//
//  YOSUserAuditRegisterRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserAuditRegisterRequest.h"

@implementation YOSUserAuditRegisterRequest {
    NSString *_ID;
    NSString *_status;
}

- (instancetype)initWithID:(NSString *)ID andStatus:(YOSUserAuditRegisterType)status {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _ID = YOSFliterNil2String(ID);
    NSString *temp = [NSString stringWithFormat:@"%zi", status];
    _status = YOSFliterNil2String(temp);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/auditRegister";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"id" : _ID,
                                        @"status" : _status
                                        }];
}

@end
