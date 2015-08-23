//
//  YOSUserForgetPassRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/23.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserForgetPassRequest.h"

@implementation YOSUserForgetPassRequest {
    NSString *_username;
}

- (instancetype)initWithUsername:(NSString *)username {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _username = YOSFliterNil2String(username);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"username" : _username,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/forget_pass";
}

@end
