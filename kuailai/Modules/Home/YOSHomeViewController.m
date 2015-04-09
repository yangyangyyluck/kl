//
//  YOSHomeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeViewController.h"
#import "YOSRegisterViewController.h"

#import "YOSUserSendCodeRequest.h"

#import "YOSWidget.h"

@interface YOSHomeViewController ()

@end

@implementation YOSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self doSendCodeRequest];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Other"] animated:YES];
    });
}

- (void)doSendCodeRequest {
    YOSUserSendCodeRequest *request = [[YOSUserSendCodeRequest alloc] initWithPhoneNumber:@"18600950783"];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (![request checkResponse]) { return; }
        [YOSWidget alertMessage:request.data[@"code"] title:@"验证码"];
    } failure:^(YTKBaseRequest *request) {
        [request checkResponse];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
