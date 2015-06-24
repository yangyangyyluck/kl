//
//  YOSUpdateUserInfoModel.h
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"

@interface YOSUpdateUserInfoModel : JSONModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *website;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *demand;

@property (nonatomic, copy) NSString *degrees;

@property (nonatomic, copy) NSString *work_experience;

@end
