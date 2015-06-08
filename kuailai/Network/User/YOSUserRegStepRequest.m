//
//  YOSUserRegStepRequest.m
//  kuailai
//
//  Created by yangyang on 15/4/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserRegStepRequest.h"

@implementation YOSUserRegStepRequest {
    NSString *_username;
    NSString *_code;
}

- (instancetype)initWithUserName:(NSString *)username validateCode:(NSString *)code {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _username = YOSFliterNil2String(username);
    _code = YOSFliterNil2String(code);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/reg_step";
}

- (id)requestArgument {
    
    return [self encodeWithDictionary:@{
                                        @"username" : _username,
                                        @"code" : _code
                                        }];
}

@end
