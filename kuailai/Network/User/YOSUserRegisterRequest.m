//
//  YOSUserRegisterRequest.m
//  kuailai
//
//  Created by yangyang on 15/4/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserRegisterRequest.h"

@implementation YOSUserRegisterRequest {
    NSString *_username;
    NSString *_ID;
    NSString *_password1;
    NSString *_password2;
}

- (instancetype)initWithUserName:(NSString *)username ID:(NSString *)ID password1:(NSString *)password1 password2:(NSString *)password2 {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _username = YOSFliterNil2String(username);
    _ID = YOSFliterNil2String(ID);
    _password1 = YOSFliterNil2String(password1);
    _password2 = YOSFliterNil2String(password2);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/register";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"nickname" : _username,
                                        @"id" : _ID,
                                        @"pwd" : _password1,
                                        @"pwd1" : _password2,
                                        }];
}

@end
