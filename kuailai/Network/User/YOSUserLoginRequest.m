//
//  YOSUserLoginRequest.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserLoginRequest.h"

@implementation YOSUserLoginRequest {
    NSString *_username;
    NSString *_pwd;
    NSString *_models;
}

- (instancetype)initWithUserName:(NSString *)username pwd:(NSString *)pwd models:(NSString *)models {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _username = YOSFliterNil2String(username);
    _pwd = YOSFliterNil2String(pwd);
    _models = YOSFliterNil2String(models);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"username" : _username,
                                        @"pwd" : _pwd,
                                        @"models" : _models,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/login";
}

@end
