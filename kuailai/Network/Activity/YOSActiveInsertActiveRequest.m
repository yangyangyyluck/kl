//
//  YOSActiveInsertActiveRequest.m
//  kuailai
//
//  Created by yangyang on 15/5/31.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActiveInsertActiveRequest.h"
#import "YOSSubmitInsetActiveModel.h"

@implementation YOSActiveInsertActiveRequest {
    YOSSubmitInsetActiveModel *_model;
}

- (instancetype)initWithModel:(YOSSubmitInsetActiveModel *)model {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _model = model;
    
    return self;
}

- (NSString *)requestUrl {
    return @"active/insertActive";
}

- (id)requestArgument {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    result[@"uid"] = YOSFliterNil2String(_model.uid);
    result[@"title"] = YOSFliterNil2String(_model.title);
    result[@"start_time"] = YOSFliterNil2String(_model.start_time);
    result[@"end_time"] = YOSFliterNil2String(_model.end_time);
    result[@"address"] = YOSFliterNil2String(_model.address);
    result[@"thumb"] = YOSFliterNil2String(_model.thumb);
    
    if (_model.close_time && ![_model.close_time isEqualToString:@""]) {
        result[@"close_time"] = _model.close_time;
    }
    
    if (_model.detail && ![_model.detail isEqualToString:@""]) {
        result[@"detail"] = _model.detail;
    }
    
    if (_model.price && ![_model.price isEqualToString:@""]) {
        result[@"price"] = _model.price;
    }
    
    if (_model.num && ![_model.num isEqualToString:@""]) {
        result[@"num"] = _model.num;
    }
    
    if (_model.is_audit && ![_model.is_audit isEqualToString:@""]) {
        result[@"is_audit"] = _model.is_audit;
    }
    
    if (_model.audit && ![_model.audit isEqualToString:@""]) {
        result[@"audit"] = _model.audit;
    }
    
    if (_model.type && ![_model.type isEqualToString:@""]) {
        result[@"type"] = _model.type;
    }
    
    if (_model.city && ![_model.city isEqualToString:@""]) {
        result[@"city"] = _model.city;
    }
    
    if (_model.area && ![_model.area isEqualToString:@""]) {
        result[@"area"] = _model.area;
    }
    
    if (_model.picList && ![_model.picList isEqualToString:@""]) {
        result[@"picList"] = _model.picList;
    }
    
    return [self encodeWithDictionary:result];
}

@end
