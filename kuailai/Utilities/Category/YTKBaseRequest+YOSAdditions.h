//
//  YTKBaseRequest+TAdditions.h
//  TGod
//
//  Created by yangyang on 15/3/23.
//  Copyright (c) 2015年 lashou.inc. All rights reserved.
//

#import "YTKBaseRequest.h"
#import "YTKRequest.h"
#import "YTKNetworkConfig.h"
@class YOSBaseResponseModel;


typedef void (^responseCustomBlock)();

@interface YTKBaseRequest (TAdditions)

// ------------------------- 根据业务逻辑做的封装 ---------------------------
// ------------------------- additions by yangyangyyluck ---------------------------

@property (nonatomic, strong, readonly) YOSBaseResponseModel *baseResponseModel;

// 该属性用于关闭debug log default NO 不关闭log
@property (nonatomic, assign, getter=isHideDebug) BOOL hideDebug;

// debug 请求字符串
- (NSString *)debugString;

// 检查响应结果
- (BOOL)checkResponse;

//是否需要显示提示
- (BOOL)checkResponse:(BOOL)showErrorMessage;

// 执行自定义错误处理 在调用 -checkResponse 前生效
- (void)performCustomResponseErrorWithStatus:(BusinessRequestStatus)status errorBlock:(responseCustomBlock)block;

// 返回过滤后的data
- (id)data;

@end
