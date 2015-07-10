//
//  YOSUserGetTagListRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetTagListRequest.h"

@implementation YOSUserGetTagListRequest {
    NSString *_uid;
}

- (instancetype)initWithUid:(NSString *)uid {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/getTagList";
}

@end
