//
//  YOSMessageModel.h
//  kuailai
//
//  Created by yangyang on 15/7/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"

@interface YOSMessageModel : JSONModel

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *hx_user;

@end
