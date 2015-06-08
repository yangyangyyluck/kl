//
//  YOSUserSendCodeRequest.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserSendCodeRequest.h"

@implementation YOSUserSendCodeRequest {
    NSString *_phoneNumber;
}

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _phoneNumber = phoneNumber;
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/sendCode";
}

- (id)requestArgument {
    
    return [self encodeWithDictionary:@{
                                        @"username" : YOSFliterNil2String(_phoneNumber)
                                        }];
}

@end
