//
//  YOSActiveGetSignUpRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/1.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveGetSignUpRequest.h"

@implementation YOSActiveGetSignUpRequest {
    NSString *_aid;
    NSString *_page;
}

- (instancetype)initWithAid:(NSString *)aid andPage:(NSString *)page {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _aid = YOSFliterNil2String(aid);
    _page = YOSFliterNil2String(page);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"aid" : _aid,
                                        @"page" : _page,
                                        }];
}

- (NSString *)requestUrl {
    return @"active/get_signUp";
}

@end
