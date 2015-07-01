//
//  YOSUserGetMyActiveListRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetMyActiveListRequest.h"

@implementation YOSUserGetMyActiveListRequest {
    NSString *_uid;
    NSString *_page;
    NSString *_status;
}

- (instancetype)initWithUid:(NSString *)uid andPage:(NSString *)page andStatus:(NSString *)status {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _page = YOSFliterNil2String(page);
    _status = YOSFliterNil2String(status);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/getMyActiveList";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"page" : _page,
                                        @"status" : _status,
                                        }];
}

@end
