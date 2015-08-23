//
//  YOSUserUppwdRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/23.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserUppwdRequest.h"

@implementation YOSUserUppwdRequest {
    NSString *_uid;
    NSString *_pwd;
    NSString *_pwd1;
    NSString *_pwd2;
}

- (instancetype)initWithUid:(NSString *)uid pwd:(NSString *)pwd pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2 {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _pwd = YOSFliterNil2String(pwd);
    _pwd1 = YOSFliterNil2String(pwd1);
    _pwd2 = YOSFliterNil2String(pwd2);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"id" : _uid,
                                        @"pwd" : _pwd,
                                        @"pwd1" : _pwd1,
                                        @"pwd2" : _pwd2
                                        }];
}

- (NSString *)requestUrl {
    return @"user/uppwd";
}

@end
