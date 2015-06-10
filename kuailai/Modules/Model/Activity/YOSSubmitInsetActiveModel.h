//
//  YOSSubmitInsetActiveModel.h
//  kuailai
//
//  Created by yangyang on 15/5/31.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"

@interface YOSSubmitInsetActiveModel : JSONModel

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *close_time;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *is_audit;

@property (nonatomic, copy) NSString *audit;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *ctype;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *picList;

@end
