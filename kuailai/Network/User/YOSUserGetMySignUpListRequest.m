//
//  YOSUserGetMySignUpListRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetMySignUpListRequest.h"

@implementation YOSUserGetMySignUpListRequest {
    NSString *_uid;
    NSString *_page;
}

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _page = YOSFliterNil2String(page);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/getMySignUpList";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"page" : _page,
                                        }];
}

@end
