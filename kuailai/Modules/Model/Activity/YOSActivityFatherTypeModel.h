//
//  YOSActivityFatherTypeModel.h
//  kuailai
//
//  Created by yangyang on 15/5/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"
#import "YOSActivitySonTypeModel.h"

@interface YOSActivityFatherTypeModel : JSONModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray <YOSActivitySonTypeModel>*ctype;

@end
