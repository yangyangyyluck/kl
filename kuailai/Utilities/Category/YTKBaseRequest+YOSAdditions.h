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
#import "AFJSONResponseSerializer+YOSAdditionsForPHP.h"
@class YOSBaseResponseModel;

typedef void (^responseCustomBlock)();

@interface YOSBaseResponseModel : NSObject

@property (nonatomic, assign) NSString *code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) id data;      // NSArray Or NSDictionary

@end

@interface YTKBaseRequest (YOSAdditions)

// ------------------------- 根据业务逻辑做的封装 ---------------------------
// ------------------------- additions by yangyangyyluck ---------------------------

@property (nonatomic, strong, readonly) YOSBaseResponseModel *yos_baseResponseModel;

// 该属性用于关闭debug log default NO 不关闭log
@property (nonatomic, assign, getter=isYos_hideDebug) BOOL yos_hideDebug;

// debug 请求字符串
- (NSString *)yos_debugString;

// 检查响应结果
- (BOOL)yos_checkResponse;

//是否需要显示提示
- (BOOL)yos_checkResponse:(BOOL)showErrorMessage;

// 执行自定义错误处理 在调用 -checkResponse 前生效
- (void)yos_performCustomResponseErrorWithStatus:(BusinessRequestStatus)status errorBlock:(responseCustomBlock)block;

// 返回过滤后的data
- (id)yos_data;

@end
