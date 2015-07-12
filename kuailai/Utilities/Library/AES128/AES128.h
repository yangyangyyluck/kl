//
//  AES128.h
//  CocoaSecurity_Test
//
//  Created by yangyang on 15/3/31.
//  Copyright (c) 2015年 lashou.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  AES128 AES/ECB/NoPadding 算法/模式/补码方式
 */
@interface AES128 : NSObject

+(NSString *)AES128Encrypt:(NSString *)plainText withKey:(NSString *)key;

+(NSString *)AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key;

@end
