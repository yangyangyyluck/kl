//
//  AFURLResponseSerialization+YOSAdditionsForPHP.m
//  kuailai
//
//  Created by yangyang on 15/4/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "AFJSONResponseSerializer+YOSAdditionsForPHP.h"
#import "JRSwizzle.h"

@implementation AFJSONResponseSerializer (YOSAdditionsForPHP)

- (instancetype)initWithPHP {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    return self;
}

+ (void)load {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(init) withMethod:@selector(initWithPHP) error:&error];
    
    if (error) {
        YOSLog(@"\r\n fatal error : JRSwizzle wrong.");
    }
    
}

@end
