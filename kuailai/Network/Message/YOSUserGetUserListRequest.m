//
//  YOSUserGetUserListRequest.m
//  kuailai
//
//  Created by yangyang on 15/7/27.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserGetUserListRequest.h"

@implementation YOSUserGetUserListRequest {
    NSString *_name;
    NSString *_page;
}

- (instancetype)initWithName:(NSString *)name andPage:(NSString *)page {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = YOSFliterNil2String(name);
    _page = YOSFliterNil2String(page);
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"name" : _name,
                                        @"page" : _page,
                                        }];
}

- (NSString *)requestUrl {
    return @"user/getUserList";
}

@end
