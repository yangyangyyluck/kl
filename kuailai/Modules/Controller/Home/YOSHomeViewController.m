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
//#import "IQKeyboardManager.h"
#import "YOSDBManager.h"

@interface YOSHomeViewController ()

@end

@implementation YOSHomeViewController {
    YOSTextView *_textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *tv = [UITextView new];
    [self.view addSubview:tv];
    tv.text = @"sss";
    tv.backgroundColor = [UIColor grayColor];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.top.mas_equalTo(150);
        
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
    }];
    
    _textView = [YOSTextView new];
    _textView.placeholder = @"sasa say.";
    [self.view addSubview:_textView];
    _textView.backgroundColor = YOSRGB(222, 222, 222);
//    _textView.text = @"safsd sasa .";
//    [_textView scrollRangeToVisible:NSMakeRange(0, 1)];
    
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(290);
        make.leading.mas_equalTo(30);
        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(44);
    }];
    
    
    YOSInputView *_inputView0 = [[YOSInputView alloc] initWithTitle:@"活动标题:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView0.placeholder = @"最多25个字";
    YOSInputView *_inputView1 = [[YOSInputView alloc] initWithTitle:@"开始时间:" selectedStatus:NO maxCharacters:25 isSingleLine:NO];
    _inputView1.pickerType = YOSInputViewPickerTypeActivity;

    [self.view addSubview:_inputView0];
    [self.view addSubview:_inputView1];
    
    [_inputView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120);
        make.leading.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(320, 44));
    }];
    
    [_inputView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.leading.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(320, 44));
    }];
}

- (void)viewDidAppear:(BOOL)animated {
//    _textView.text = @"safsd sasa112 123 123  .";
    NSLog(@"%@", NSStringFromCGSize(_textView.contentSize));
    
}

- (void)doSendCodeRequest {
    YOSUserSendCodeRequest *request = [[YOSUserSendCodeRequest alloc] initWithPhoneNumber:@"18600950783"];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (![request yos_checkResponse]) { return; }
        [YOSWidget alertMessage:request.yos_data[@"code"] title:@"验证码"];
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    
//    [[YOSDBManager sharedManager] chooseTable:YOSDBManagerTableTypeCargoData isUseQueue:YES];
    
    NSArray *citys = @[@"北京", @"上海", @"广州", @"深圳"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:citys];
    
    NSDictionary *dict = @{
                           YOSDBTableCargoDataKey : @(YOSDBTableCargoKeyTypeChooseCity),
                           YOSDBTableCargoDataValue : data
                           };
    
    [[YOSDBManager sharedManager] chooseTable:YOSDBManagerTableTypeCargoData isUseQueue:YES];
    NSArray *arr = [[YOSDBManager sharedManager] getCargoDataWithKey:YOSDBTableCargoKeyTypeChooseCity];
    
    NSLog(@"arr is %@", arr);
    
    return;
    
    YOSLog(@"%@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
    YOSEditViewController *editVC = [[YOSEditViewController alloc] initWithTitle:@"活动标题" placeholder:@"最多输入50个字" maxCharacters:15];
    [self presentViewController:editVC animated:YES completion:nil];
    
    return;
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
        });
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
