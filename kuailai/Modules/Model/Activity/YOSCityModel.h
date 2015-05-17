//
//  YOSCityModel.h
//  kuailai
//
//  Created by yangyang on 15/5/16.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"
#import "YOSRegionModel.h"

@interface YOSCityModel : JSONModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, strong) NSArray <YOSRegionModel>*area;

@end
