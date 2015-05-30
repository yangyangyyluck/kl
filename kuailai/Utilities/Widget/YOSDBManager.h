//
//  YOSDBManager.h
//  kuailai
//
//  Created by yangyang on 15/5/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YOSDBManagerTableType) {
    YOSDBManagerTableTypeCargoData,     // 存杂货
};

/**
 *  yos_cargo  id => blob [id 对应 blob数据], id值
 */
typedef NS_ENUM(NSUInteger, YOSDBTableCargoKeyType){
    YOSDBTableCargoKeyTypeChooseCity = 1,   // 活动中选择城市数据
    YOSDBTableCargoKeyTypeActivityType = 2, // 活动类型
};

/**
 *  sqlite 存各种零散数据
 */
extern NSString * const YOSDBTableCargoDataKey;
extern NSString * const YOSDBTableCargoDataValue;

@interface YOSDBManager : NSObject

+ (instancetype)sharedManager;

- (void)chooseTable:(YOSDBManagerTableType)tableType isUseQueue:(BOOL)status;

/** -----------deal with table : yos_cagro------------ */

- (void)updateCargoDataWithDictionary:(NSDictionary *)dict isUseQueue:(BOOL)status;

- (id)getCargoDataWithKey:(YOSDBTableCargoKeyType)key;

+ (void)setDataWithTable:(YOSDBManagerTableType)tableType cargoDataKey:(YOSDBTableCargoKeyType)key cargoDataValue:(id)value;

/** -----------deal with table : yos_cagro------------ */



@end
