//
//  YOSFriendModel.h
//  kuailai
//
//  Created by yangyang on 15/6/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"

@interface YOSAuditModel : JSONModel

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *status;

/** 活动审核的时候使用 YOSActivityAuditIndividualView & YOSActivityAuditViewController */
@property (nonatomic, copy) NSString *uid;

@end
