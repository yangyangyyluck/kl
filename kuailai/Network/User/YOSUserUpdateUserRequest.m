//
//  YOSUserUpdateUserRequest.m
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUserUpdateUserRequest.h"
#import "YOSUpdateUserInfoModel.h"

@implementation YOSUserUpdateUserRequest {
    YOSUpdateUserInfoModel *_model;
}

- (instancetype)initWithUpdateUserInfoModel:(YOSUpdateUserInfoModel *)model {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _model = model;
    
    return self;
}

- (id)requestArgument {
    return [self encodeWithDictionary:@{
                                        @"id" : YOSFliterNil2String(_model.ID),
                                        @"nickname" : YOSFliterNil2String(_model.nickname),
                                        @"email" : YOSFliterNil2String(_model.email),
                                        @"company" : YOSFliterNil2String(_model.company),
                                        @"position" : YOSFliterNil2String(_model.position),
                                        @"sex" : YOSFliterNil2String(_model.sex),
                                        @"website" : YOSFliterNil2String(_model.website),
                                        @"tel" : YOSFliterNil2String(_model.tel),
                                        @"demand" : YOSFliterNil2String(_model.demand),
                                        @"degrees" : YOSFliterNil2String(_model.degrees),
                                        @"work_experience" : YOSFliterNil2String(_model.work_experience),
                                        }];
}

- (NSString *)requestUrl {
    return @"user/updateUser";
}

@end
