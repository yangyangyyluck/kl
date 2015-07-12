//
//  YOSUserAllAuditRegisterRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserAllAuditRegisterRequest.h"

@implementation YOSUserAllAuditRegisterRequest {
    NSString *_aid;
}

- (instancetype)initWithAid:(NSString *)aid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _aid = YOSFliterNil2String(aid);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/allAuditRegister";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"aid" : _aid,
                                        }];
}

@end
