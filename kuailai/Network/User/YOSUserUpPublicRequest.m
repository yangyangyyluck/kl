//
//  YOSUserUpPublicRequest.m
//  kuailai
//
//  Created by yangyang on 15/8/17.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserUpPublicRequest.h"

@implementation YOSUserUpPublicRequest {
    NSString *_uid;
    NSString *_isPublic;
}

- (instancetype)initWithUid:(NSString *)uid isPublic:(NSString *)isPublic {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _isPublic = YOSFliterNil2String(isPublic);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"is_public" : _isPublic,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/upPublic";
}

@end
