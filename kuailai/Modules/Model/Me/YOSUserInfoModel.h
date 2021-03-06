//
//  YOSUserInfoModel.h
//  kuailai
//
//  Created by yangyang on 15/6/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "JSONModel.h"

@interface YOSUserInfoModel : JSONModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *crttime;

@property (nonatomic, copy) NSString *logintime;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *sex_name;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *website;

@property (nonatomic, copy) NSString *degree;

@property (nonatomic, copy) NSString *degree_name;

@property (nonatomic, copy) NSString *work_experience;

@property (nonatomic, copy) NSString *work_experience_name;

@property (nonatomic, copy) NSString *demand;

@property (nonatomic, copy) NSString *tel;

/** 是否接受陌生人消息 defalut 0 = 接受 */
@property (nonatomic, copy) NSString *is_public;

/** 环信 */
@property (nonatomic, copy) NSString *hx_user;

@property (nonatomic, copy) NSString *hx_pwd;

/** 活动审核的时候使用 YOSActivityAuditIndividualView & YOSActivityAuditViewController */
@property (nonatomic, copy) NSString *uid;

/** 朋友关系 */
@property (nonatomic, assign) YOSFriendType friendType;

/** YOSAddBuddyCell 是否点击过添加按钮 */
@property (nonatomic, assign) BOOL isTappedAddButton;

@end
