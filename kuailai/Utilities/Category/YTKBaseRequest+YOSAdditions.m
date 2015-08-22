//
//  YTKBaseRequest+TAdditions.m
//  TGod
//
//  Created by yangyang on 15/3/23.
//  Copyright (c) 2015年 lashou.inc. All rights reserved.
//

#import "YTKBaseRequest+YOSAdditions.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

#ifdef DEBUG
#define kMessage    @"后台没有返回message, 请Log输出-debugString确认."
#else
#define kMessage    @"请求错误"
#endif

@implementation YOSBaseResponseModel

@end

@implementation YTKBaseRequest (YOSAdditions)

// ------------------------- 根据业务逻辑做的封装 ---------------------------
// -------------------- additions by yangyangyyluck --------------------

- (NSMutableDictionary *)yos_customBlocks {
   id customBlocks = objc_getAssociatedObject(self, @"customBlocks");
    
    if (!customBlocks) {
        objc_setAssociatedObject(self, @"customBlocks", [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, @"customBlocks");
}

- (void)setYos_CustomBlocks:(NSMutableDictionary *)customBlocks {
    objc_setAssociatedObject(self, @"customBlocks",customBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYos_hideDebug:(BOOL)hideDebug {
    objc_setAssociatedObject(self, @"hideDebug",@(hideDebug), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isYos_hideDebug {
    NSNumber *hideDebug = objc_getAssociatedObject(self, @"hideDebug");
    return [hideDebug boolValue];
}

- (YOSBaseResponseModel *)yos_baseResponseModel {
    return objc_getAssociatedObject(self, @"baseResponseModel");
}

- (void)setYos_baseResponseModel:(YOSBaseResponseModel *)baseResponseModel {
    objc_setAssociatedObject(self, @"baseResponseModel",baseResponseModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)yos_debugString {
    
    return [NSString stringWithFormat:@"\r\n\r\nurl : \r\n%@%@\r\n\r\n parms : \r\n%@\r\n\r\n response : \r\n%@\r\n\r\n",(![self.baseUrl isEqualToString:@""]) ? self.baseUrl : [YTKNetworkConfig sharedInstance].baseUrl, self.requestUrl, self.requestArgument, self.responseJSONObject];
}

- (void)yos_performCustomResponseErrorWithStatus:(BusinessRequestStatus)status errorBlock:(responseCustomBlock)block {
    
    if (!block) return;
    
    self.yos_customBlocks[@(status)] = block;
}

- (BOOL)yos_checkResponse {
    return [self yos_checkResponse:YES];
}

- (BOOL)yos_checkResponse:(BOOL)showErrorMessage {
    
    if (!self.isYos_hideDebug) {
        YOSLog(@"%@", self.yos_debugString);
    }
    
    if (!self.responseJSONObject) {
        // show some message
        YOSLog(@"\r\n\r\nnetwork error, response JSON is nil, response headers : \r\n%@\r\n", self.responseHeaders);
        
        // 请求失败 HTTP状态码 不在200-299 网络错误等非业务类型错误
        if (![self statusCodeValidator]) {
            if (!self.isYos_hideDebug) {
                YOSLog(@"\r\n\r\nnetwork error, response headers : \r\n%@\r\n", self.responseHeaders);
            }
            
            if ([self yosp_performCustomWithStatus:BusinessRequestStatusFailure]) return NO;
            if (showErrorMessage) {
                // 系统统一处理网络异常
                [SVProgressHUD showErrorWithStatus:YOSNetworkErrorFailure maskType:SVProgressHUDMaskTypeClear];
            }
            
            return NO;
        }
        
        return NO;
    }
    
    
    
    YOSBaseResponseModel *baseResponseModel = [YOSBaseResponseModel new];
    
    // 转responseJSONObject中的数据为字符串
    NSDictionary *responseJSONObject = [self recursionTransferDataToString:self.responseJSONObject];
    
    baseResponseModel.code = responseJSONObject[@"code"];
    baseResponseModel.msg = responseJSONObject[@"msg"];
    baseResponseModel.data = responseJSONObject[@"data"];
    
    self.yos_baseResponseModel = baseResponseModel;
    
    // 处理业务错误
    switch ([self.yos_baseResponseModel.code integerValue]) {
            // 请求成功
        case BusinessRequestStatusSuccess: {
            
            if ([self yosp_performCustomWithStatus:BusinessRequestStatusSuccess]) return YES;
            
            // 请求成功都取消HUD
            [SVProgressHUD dismiss];
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                
            }
            
            return YES;
            
        }
            
            // 坏请求
        case BusinessRequestStatusBadRequest: {
            
            if ([self yosp_performCustomWithStatus:BusinessRequestStatusBadRequest]) return NO;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                
                if (self.yos_baseResponseModel.msg) {
                    [SVProgressHUD showErrorWithStatus:self.yos_baseResponseModel.msg maskType:SVProgressHUDMaskTypeClear];
                } else {
                    [SVProgressHUD showErrorWithStatus:YOSNetworkErrorBadRequest maskType:SVProgressHUDMaskTypeClear];
                }
                
            }
            
            return NO;
        }
            
            // 无权限
        case BusinessRequestStatusNoAuthorization: {
            
            if ([self yosp_performCustomWithStatus:BusinessRequestStatusNoAuthorization]) return NO;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                [SVProgressHUD showErrorWithStatus:YOSNetworkErrorNoAuthorization maskType:SVProgressHUDMaskTypeClear];
            }
            
            return NO;
            
        }
            
        default: {
            
            if ([self yosp_performCustomWithStatus:BusinessRequestStatusDefault]) return NO;
            
            if (showErrorMessage) {
                // 系统统一处理网络异常
                [SVProgressHUD showErrorWithStatus:YOSNetworkErrorDefault maskType:SVProgressHUDMaskTypeClear];
            }
            
            return NO;
        }
    }
}

- (id)yos_data {
    id data = self.yos_baseResponseModel.data;
    
    data = [self yosp_fliterWithData:data];
    
    return data;
}

#pragma mark - private methods

// 处理customBlock
- (BOOL)yosp_performCustomWithStatus:(BusinessRequestStatus)status {
    
    responseCustomBlock block = self.yos_customBlocks[@(status)];
    
    // 处理自定义customBlock
    if (block) {
        block();
        return YES;
    } else {
        return NO;
    }
}

// 过滤数据
- (id)yosp_fliterWithData:(id)data {
    
    if ([data isKindOfClass:[NSNull class]]) return nil;
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray *)data;
        
        if (dataArr.count == 0) {
            return nil;
        }
    }
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = (NSDictionary *)data;
        
        id result = [dataDict valueForKeyPath:@"data"];
        if (result && [result isKindOfClass:[NSNull class]]) {
            return nil;
        }
        
    }
    
    return data;
}

- (id)recursionTransferDataToString:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                dictM[key] = [self recursionTransferDataToString:obj];
            } else {
                dictM[key] = [obj description];
            }
            
        }];

        return dictM;
    }
    
    if ([data isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                [arrM addObject:[self recursionTransferDataToString:obj]];
            } else {
                [arrM addObject:[obj description]];
            }
            
        }];
        
        return arrM;
    }
    
    return [data description];
}

- (NSTimeInterval)yos_requestTimeoutInterval {
    return 25;
}

+ (void)load {
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(requestTimeoutInterval) withMethod:@selector(yos_requestTimeoutInterval) error:&error];
    
    if (error) {
        YOSLog(@"\r\n fatal error : JRSwizzle wrong.");
    }
    
}

@end
