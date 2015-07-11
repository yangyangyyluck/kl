//
//  YOSUserDelTagRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserDelTagRequest.h"

@implementation YOSUserDelTagRequest {
    NSString *_ID;
}

- (instancetype)initWithID:(NSString *)ID {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _ID = YOSFliterNil2String(ID);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"id" : _ID,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/del_tag";
}

@end
