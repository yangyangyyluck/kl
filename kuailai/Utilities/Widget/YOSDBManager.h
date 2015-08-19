//
//  YOSDBManager.h
//  kuailai
//
//  Created by yangyang on 15/5/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  yos_cargo  id => blob [id 对应 blob数据], id值
 *
 *  sqlite 存各种零散数据
 */

typedef NS_ENUM(NSUInteger, YOSDBTableCargoKeyType){
    YOSDBTableCargoKeyTypeChooseCity = 1,   // 活动中选择城市数据
    YOSDBTableCargoKeyTypeActivityType = 2, // 活动类型
};

@interface YOSDBManager : NSObject

+ (instancetype)sharedManager;

/** -----------deal with table : yos_cagro------------ */

- (void)updateCargoDataWithDictionary:(NSDictionary *)dict isUseQueue:(BOOL)status;

- (id)getCargoDataWithKey:(YOSDBTableCargoKeyType)key;

- (void)setCargoKey:(YOSDBTableCargoKeyType)key cargoValue:(id)value;

/** -----------deal with table : yos_cagro------------ */

/**
 *  user是自己服务器usernam字段, buddy是[环信注册账号]
 */
/** -----------deal with table : yos_buddyrequest------------ */
- (void)updateBuddyRequestWithCurrentUser:(NSString *)current buddy:(NSString *)buddy message:(NSString *)message;

- (void)deleteBuddyRequestWithCurrentUser:(NSString *)current buddy:(NSString *)buddy;

- (NSArray *)getBuddyListWithUsername:(NSString *)username;
/** -----------deal with table : yos_buddyrequest------------ */

/**
 *  username是hx_user字段[环信注册账号]
 */
/** -----------deal with table : yos_userinfo------------ */
- (void)updateUserInfoWithUsername:(NSString *)username json:(NSString *)json;

- (NSString *)getUserInfoJsonWithUsername:(NSString *)username;
/** -----------deal with table : yos_userinfo------------ */

/** -----------deal with table : yos_newestchat------------ */
- (void)updateNewestChatWithUsername:(NSString *)username update_time:(NSString *)update_time;

- (NSArray *)getNewestChatUsernames;
/** -----------deal with table : yos_newestchat------------ */


@end
