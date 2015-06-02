//
//  YOSRegisterViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSRegisterViewController.h"
#import "YOSRegStepTwoViewController.h"
#import "YOSAccessoryView.h"

#import "YOSUserSendCodeRequest.h"
#import "YOSUserRegStepRequest.h"

#import "Masonry.h"
#import "YOSWidget.h"

#import "SVProgressHUD+YOSAdditions.h"
#import "UIColor+hex.h"
#import "UIImage+YOSAdditions.h"


static const NSUInteger kTimeMaxCount = 16;

@interface YOSRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *registerCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1HeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@end

@implementation YOSRegisterViewController {
    NSUInteger _timeCount;
    NSTimer *_timer;
    
    BOOL _isRegisterCodeButtonWaitting;
    BOOL _isNextStepButtonWaitting;
    
    YOSAccessoryView *_accessoryView1;
    YOSAccessoryView *_accessoryView2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNavTitle:@"注册"];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    [self setupBackArrow];
    
    self.lineView1HeightConstraint.constant = 0.5;
    self.lineView2HeightConstraint.constant = 0.5;
    
    self.registerCodeButton.layer.cornerRadius = 10;
    self.registerCodeButton.layer.masksToBounds = YES;
    
    self.nextStepButton.layer.cornerRadius = 20.5;
    self.nextStepButton.layer.masksToBounds = YES;

    YOSWSelf(weakSelf);
    YOSAccessoryView *accessoryView1 = [[YOSAccessoryView alloc] initWithDefaultPlaceBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    [accessoryView1 buttonWithTitle:@"获取验证码" target:weakSelf method:@selector(signPasswordTextField) position:YOSAccessoryViewPositionRight];
    
    _accessoryView1 = accessoryView1;
    self.userNameTextField.inputAccessoryView = accessoryView1;
    
    YOSAccessoryView *accessoryView2 = [[YOSAccessoryView alloc] initWithDefaultPlaceBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    [accessoryView2 buttonWithTitle:@"下一步" target:weakSelf method:@selector(clickNextStepButton:) position:YOSAccessoryViewPositionRight];
    
    _accessoryView2 = accessoryView2;
    self.verifyCodeTextField.inputAccessoryView = accessoryView2;
    
}

- (UIView *)accessoryViewWithTitle:(NSString *)title method:(SEL)sel {
    UIView *accessoryView = [UIView new];
    accessoryView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = YOSColorGreen;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [accessoryView addSubview:btn];
    
    accessoryView.frame = CGRectMake(0, 0, YOSScreenWidth, 44);
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    return accessoryView;
}

#pragma mark - network request
- (void)sendCodeRequestWithMobileNumber:(NSString *)mobileNumber {
    
    YOSUserSendCodeRequest *request = [[YOSUserSendCodeRequest alloc] initWithPhoneNumber:mobileNumber];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
            [SVProgressHUD showWithStatus:@"验证码已发送到您手机~"];
        }];
        
        if (![request yos_checkResponse]) {
            return;
        }
        
        // 真机调试时候alert, 模拟器不alert
        if (DEBUG && [request.yos_data[@"code"] isKindOfClass:[NSString class]]) {
            [SVProgressHUD showInfoWithStatus:request.yos_data[@"code"]];
        } else {
            [SVProgressHUD showInfoWithStatus:@"验证码已发送，请查收~"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

- (void)sendUserReqStepRequestWithUserName:(NSString *)username validateCode:(NSString *)code {
    YOSUserRegStepRequest *request = [[YOSUserRegStepRequest alloc] initWithUserName:username validateCode:code];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusBadRequest errorBlock:^{
            
            [SVProgressHUD showErrorWithStatus:request.yos_baseResponseModel.msg];
        }];
        
        if (![request yos_checkResponse]) {
            return;
        }
        
        // now can get remote server userid
        YOSLog(@"\r\n\r\nuser id is %@", request.yos_data[@"id"]);
        
        [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeySignInID value:request.yos_data[@"id"]];
        
        // 存入mobile number
        [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentMobileNumber value:username];
        
        YOSRegStepTwoViewController *regStepTwoVC = [YOSRegStepTwoViewController viewControllerFromStoryboardWithSBName:@"Register"];
        
        [self.navigationController pushViewController:regStepTwoVC animated:YES];
        
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [request yos_checkResponse];
        _timeCount = 0;
    }];
}

#pragma mark - touch event

- (void)signPasswordTextField {
    [self clickRegisterCodeButton:nil];
}

- (IBAction)clickRegisterCodeButton:(UIButton *)sender {
    NSLog(@"%s", __func__);

    NSString *username = self.userNameTextField.text;
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (username.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号为11位哦~"];
        return;
    }
    
    if (self.registerCodeButton.enabled) {
        [self registerCodeBtnDisEnabled];
        
        [self.verifyCodeTextField becomeFirstResponder];
        
        // 发送验证码请求
        [self sendCodeRequestWithMobileNumber:username];
        
        // _accessoryView1 变为下一步
        YOSWObject(_verifyCodeTextField, wVerifyCodeTextField);
        [_accessoryView1 buttonWithTitle:@"下一步" target:wVerifyCodeTextField method:@selector(becomeFirstResponder) position:YOSAccessoryViewPositionRight];
        
        _timeCount = kTimeMaxCount;
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(changeTime) userInfo:nil repeats:kTimeMaxCount];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
}

- (void)changeTime {
    
    if (_timeCount > 1) {
        
        _timeCount--;
        [self.registerCodeButton setTitle:[NSString stringWithFormat:@"%zis后可重发", _timeCount] forState:UIControlStateDisabled];
        
    } else {
        [_timer invalidate];
        [self.registerCodeButton setTitle:[NSString stringWithFormat:@"%zis后可重发", kTimeMaxCount] forState:UIControlStateDisabled];
    
        // _accessoryView1 变回 获取验证码
        YOSWSelf(weakSelf);
        [_accessoryView1 buttonWithTitle:@"获取验证码" target:weakSelf method:@selector(signPasswordTextField) position:YOSAccessoryViewPositionRight];
        
        [self registerCodeBtnEnabled];
    }
    
}

- (void)registerCodeBtnDisEnabled {
    self.registerCodeButton.enabled = NO;
    self.registerCodeButton.backgroundColor = YOSColorGray;
}

- (void)registerCodeBtnEnabled {
    self.registerCodeButton.enabled = YES;
    self.registerCodeButton.backgroundColor = YOSColorGreen;
}

- (IBAction)clickNextStepButton:(UIButton *)sender {
    NSLog(@"%s", __func__);

    NSString *username = self.userNameTextField.text;
    NSString *password = self.verifyCodeTextField.text;
    
    if (username.length != 11 ) {
        [SVProgressHUD showErrorWithStatus:@"手机号为11位哦~"];
        return;
    }
    
    if (password.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"验证码为6位哦~"];
        return;
    }
    
    [_verifyCodeTextField endEditing:YES];
    
    [self sendUserReqStepRequestWithUserName:username validateCode:password];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // tag 0 -> username
    if (textField.tag == 0 && textField.text.length >= 11) {
        return NO;
    }
    
    // tag 1 -> password
    if (textField.tag == 1 && textField.text.length >= 6) {
        return NO;
    }
    
    return [YOSWidget validateNumberWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
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
