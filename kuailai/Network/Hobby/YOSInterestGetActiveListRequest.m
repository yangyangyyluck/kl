//
//  YOSInterestGetActiveListRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/15.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSInterestGetActiveListRequest.h"

@implementation YOSInterestGetActiveListRequest {
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

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"page" : _page,
                                        }];
}

- (NSString *)requestUrl {
    return @"interest/getActiveList";
}

@end
