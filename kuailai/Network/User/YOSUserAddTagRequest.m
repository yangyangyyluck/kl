//
//  YOSUserAddTagRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserAddTagRequest.h"

@implementation YOSUserAddTagRequest {
    NSString *_uid;
    NSString *_string;
}

- (instancetype)initWithUid:(NSString *)uid tagString:(NSString *)string {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uid = YOSFliterNil2String(uid);
    _string = YOSFliterNil2String(string);
    
    return self;
}

- (NSString *)requestUrl {
    return @"user/add_tag";
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"uid" : _uid,
                                        @"name" : _string,
                                        }];
}

@end
