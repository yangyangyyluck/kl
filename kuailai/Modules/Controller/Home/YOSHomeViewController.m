//
//  YOSHomeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/8.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHomeViewController.h"
#import "YOSRegisterViewController.h"
#import "YOSEditViewController.h"
#import "YOSInputView.h"

#import "YOSUserSendCodeRequest.h"

#import "YOSWidget.h"
#import "YOSTextView.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "YOSDBManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "YOSTextField.h"
#import "YOSGetActiveListRequest.h"
#import "YOSActivityListModel.h"
#import "YOSUserLoginRequest.h"
#import "YOSUserInfoModel.h"

@interface YOSHomeViewController ()

@property (nonatomic, strong) NSMutableArray *activityListModels;

@end

@implementation YOSHomeViewController {
    YOSTextView *_textView;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = @{@"name" : @"yy", @"pass" : @"abc"};
    
    NSString *str = yos_encodeWithDictionary(dict);
    
    NSLog(@"%@", str);
}

#pragma mark - event response

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    NSString *string = @"3";
    
    if ([string isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
        });
    }
    
    if ([string isEqualToString:@"2"]) {
        YOSGetActiveListRequest *request = [[YOSGetActiveListRequest alloc] initWithCity:YOSCityTypeBJ page:0 start_time:0 type:0];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
    if ([string isEqualToString:@"3"]) {
        YOSUserLoginRequest *request = [[YOSUserLoginRequest alloc] initWithUserName:@"18600950783" pwd:@"123123" models:[[UIDevice currentDevice] model]];
        
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([request yos_checkResponse]) {
                
                [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentUserInfoDictionary value:request.yos_data];
                
                YOSUserInfoModel *model = [[YOSUserInfoModel alloc] initWithDictionary:request.yos_data error:nil];
                
                if (model.ID) {
                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginID value:model.ID];
                    YOSLog(@"\r\n\r\n had set LoginID");
                }
                
                if (model.username) {
                    [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginMobileNumber value:model.username];
                    YOSLog(@"\r\n\r\n had set LoginMobile");
                }
                
            }
        } failure:^(YTKBaseRequest *request) {
            [request yos_checkResponse];
        }];
    }
    
}

#pragma mark - network


#pragma mark - getter & setter

- (NSMutableArray *)activityListModels {
    if (!_activityListModels) {
        _activityListModels = [NSMutableArray array];
    }
    
    return _activityListModels;
}

@end
