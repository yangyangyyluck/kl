//
//  YOSActivityDetailViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityDetailViewController.h"

#import "YOSActiveGetActiveRequest.h"

#import "YOSActivityDetailModel.h"

@interface YOSActivityDetailViewController ()

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, strong) YOSActivityDetailModel *activityDetailModel;

@end

@implementation YOSActivityDetailViewController

- (instancetype)initWithActivityId:(NSString *)activityId {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityId = activityId;
    
    [self sendNetworkRequest];
    
    return self;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupSubviews {
    
}

#pragma mark - network

- (void)sendNetworkRequest {
    YOSActiveGetActiveRequest *request = [[YOSActiveGetActiveRequest alloc] initWithId:self.activityId];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            self.activityDetailModel = [[YOSActivityDetailModel alloc] initWithDictionary:request.yos_data error:nil];
            
            NSLog(@"%s", __func__);
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

@end
