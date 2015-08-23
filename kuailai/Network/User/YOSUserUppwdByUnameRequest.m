//
//  YOSUserUppwdByUnameRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/23.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserUppwdByUnameRequest.h"

@implementation YOSUserUppwdByUnameRequest {
    NSString *_uid;
    NSString *_code;
    NSString *_pwd1;
    NSString *_pwd2;
}

- (instancetype)initWithUid:(NSString *)uid code:(NSString *)code pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2 {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _code = YOSFliterNil2String(code);
    _pwd1 = YOSFliterNil2String(pwd1);
    _pwd2 = YOSFliterNil2String(pwd2);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"id" : _uid,
                                        @"code" : _code,
                                        @"pwd1" : _pwd1,
                                        @"pwd2" : _pwd2,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/uppwd_by_uname";
}

@end
