//
//  NSString+YOSAdditions.m
//  kuailai
//
//  Created by yangyang on 15/6/4.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "NSString+YOSAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YOSAdditions)

- (NSString *)yos_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (id)yos_toJSONObject {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return result;
}

@end
