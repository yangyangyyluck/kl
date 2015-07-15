//
//  YOSUserConfirmRegisterRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserConfirmRegisterRequest.h"

@implementation YOSUserConfirmRegisterRequest {
    NSString *_uid;
    NSString *_aid;
}

- (instancetype)initWithUid:(NSString *)uid aid:(NSString *)aid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _aid = YOSFliterNil2String(aid);
    _uid = YOSFliterNil2String(uid);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/confirmRegister";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"aid" : _aid,
                                        @"uid" : _uid,
                                        }];
}

@end
