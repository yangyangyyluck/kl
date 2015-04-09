//
//  YTKBaseRequest+TAdditions.m
//  TGod
//
//  Created by yangyang on 15/3/23.
//  Copyright (c) 2015年 lashou.inc. All rights reserved.
//

#import "YTKBaseRequest+YOSAdditions.h"
#import <objc/runtime.h>

#ifdef DEBUG
#define kMessage    @"后台没有返回message, 请Log输出-debugString确认."
#else
#define kMessage    @"请求错误"
#endif

@interface YOSBaseResponseModel : NSObject

@property (nonatomic, assign) NSString *code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation YOSBaseResponseModel

@end

@implementation YTKBaseRequest (YOSAdditions)

// ------------------------- 根据业务逻辑做的封装 ---------------------------
// -------------------- additions by yangyangyyluck --------------------

- (NSMutableDictionary *)customBlocks {
   id customBlocks = objc_getAssociatedObject(self, @"customBlocks");
    
    if (!customBlocks) {
        objc_setAssociatedObject(self, @"customBlocks", [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, @"customBlocks");
}

- (void)setCustomBlocks:(NSMutableDictionary *)customBlocks {
    objc_setAssociatedObject(self, @"customBlocks",customBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHideDebug:(BOOL)hideDebug {
    objc_setAssociatedObject(self, @"hideDebug",@(hideDebug), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isHideDebug {
    NSNumber *hideDebug = objc_getAssociatedObject(self, @"hideDebug");
    return [hideDebug boolValue];
}

- (YOSBaseResponseModel *)baseResponseModel {
    return objc_getAssociatedObject(self, @"baseResponseModel");
}

- (void)setBaseResponseModel:(YOSBaseResponseModel *)baseResponseModel {
    objc_setAssociatedObject(self, @"baseResponseModel",baseResponseModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)debugString {
    
    return [NSString stringWithFormat:@"\r\n\r\nurl : \r\n%@%@\r\n\r\n parms : \r\n%@\r\n\r\n response : \r\n%@\r\n\r\n",(![self.baseUrl isEqualToString:@""]) ? self.baseUrl : [YTKNetworkConfig sharedInstance].baseUrl, self.requestUrl, self.requestArgument, self.responseJSONObject];
}

- (void)performCustomResponseErrorWithStatus:(BusinessRequestStatus)status errorBlock:(responseCustomBlock)block {
    
    if (!block) return;
    
    self.customBlocks[@(status)] = block;
}

- (BOOL)checkResponse {
    return [self checkResponse:YES];
}

- (BOOL)checkResponse:(BOOL)showErrorMessage {
    
    if (!self.responseJSONObject) {
        // show some message
        return NO;
    }
    
    // 请求失败 HTTP状态码 不在200-299 网络错误等非业务类型错误
    if (![self statusCodeValidator]) {
        if (!self.isHideDebug) {
            YOSLog(@"\r\n\r\nnetwork error, response headers : \r\n%@\r\n", self.responseHeaders);
        }
        
        if ([self performCustomWithStatus:BusinessRequestStatusFailure]) return NO;
        if (showErrorMessage) {
            // 系统统一处理网络异常
            
        }
        
        return NO;
    }
    
    if (!self.isHideDebug) {
        YOSLog(@"%@", self.debugString);
    }
    
    YOSBaseResponseModel *baseResponseModel = [YOSBaseResponseModel new];
    baseResponseModel.code = self.responseJSONObject[@"code"];
    baseResponseModel.msg = self.responseJSONObject[@"msg"];
    
    // 转data中的数据为字符串
    NSDictionary *dict = self.responseJSONObject[@"data"];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        dictM[key] = [obj description];
    }];
    baseResponseModel.data = dictM;
    
    self.baseResponseModel = baseResponseModel;
    
    // 处理业务错误
    switch ([self.baseResponseModel.code integerValue]) {
            // 请求成功
        case BusinessRequestStatusSuccess: {
            
            if ([self performCustomWithStatus:BusinessRequestStatusSuccess]) return YES;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                
            }
            
            return YES;
            
        }
            
            // 坏请求
        case BusinessRequestStatusBadRequest: {
            
            if ([self performCustomWithStatus:BusinessRequestStatusBadRequest]) return NO;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                
            }
            
            return NO;
        }
            
            // 无权限
        case BusinessRequestStatusNoAuthorization: {
            
            if ([self performCustomWithStatus:BusinessRequestStatusNoAuthorization]) return NO;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                
            }
            
            return NO;
            
        }
            
        default: {
            
            if ([self performCustomWithStatus:BusinessRequestStatusDefault]) return NO;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                
            }
            
            return NO;
        }
    }
}

- (id)data {
    id data = self.baseResponseModel.data;
    
    data = [self fliterWithData:data];
    
    return data;
}

#pragma mark - private methods

// 处理customBlock
- (BOOL)performCustomWithStatus:(BusinessRequestStatus)status {
    

    
    responseCustomBlock block = self.customBlocks[@(status)];
    
    // 处理自定义customBlock
    if (block) {
        block();
        return YES;
    } else {
        return NO;
    }
}

// 过滤数据
- (id)fliterWithData:(id)data {
    
    if ([data isKindOfClass:[NSNull class]]) return nil;
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray *)data;
        
        if (dataArr.count == 0) {
            return nil;
        }
    }
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = (NSDictionary *)data;
        
        id result = [dataDict valueForKeyPath:@"result"];
        if (result && [result isKindOfClass:[NSNull class]]) {
            return nil;
        }
        
    }
    
    return data;
}

@end
