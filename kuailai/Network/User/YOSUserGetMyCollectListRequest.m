//
//  YOSUserGetMyCollectListRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/19.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetMyCollectListRequest.h"

@implementation YOSUserGetMyCollectListRequest {
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
    return @"user/getMyCollectList";
}

@end
