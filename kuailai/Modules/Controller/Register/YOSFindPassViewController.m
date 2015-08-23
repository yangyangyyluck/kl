//
//  YOSFindPassViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSFindPassViewController.h"
#import "YOSBaseNavigationViewController.h"


#import "YOSUserForgetPassRequest.h"
#import "YOSUserUppwdByUnameRequest.h"

#import "YOSWidget.h"
#import "SVProgressHUD.h"
#import "GVUserDefaults+YOSProperties.h"

static const NSUInteger kTimeMaxCount = 16;

@interface YOSFindPassViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registerCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView0HeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation YOSFindPassViewController {
    NSString *_uid;
    
    NSUInteger _timeCount;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setupBackArrow];
    
    [self setupNavTitle:@"找回密码"];
    
    [self setupSubviews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {

    self.lineView0HeightConstraint.constant = 0.5;
    self.lineView1HeightConstraint.constant = 0.5;
    self.lineView2HeightConstraint.constant = 0.5;
    
    self.showPwdButton.layer.cornerRadius = 10;
    self.showPwdButton.layer.masksToBounds = YES;
    
    self.registerCodeButton.layer.cornerRadius = 10;
    self.registerCodeButton.layer.masksToBounds = YES;
    [self.registerCodeButton addTarget:self action:@selector(tappedRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.sureButton.layer.cornerRadius = 20.5;
    self.sureButton.layer.masksToBounds = YES;
    
}

- (IBAction)clickShowButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
    if ([sender.currentTitle isEqualToString:@"显示密码"]) {
        [sender setTitle:@"隐藏密码" forState:UIControlStateNormal];
        _pwdTextField.secureTextEntry = NO;
    } else {
        [sender setTitle:@"显示密码" forState:UIControlStateNormal];
        _pwdTextField.secureTextEntry = YES;
    }
}

- (IBAction)clickSureButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
    
    if (_phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号是11位哦~"];
        return;
    }
    
    if (!_verifyCodeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码哦~"];
        return;
    }
    
    if (_pwdTextField.text.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"密码最多20位哦~"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self sendNetworkRequestWithUpdatePassword];
}

#pragma mark - network

- (void)sendNetworkRequestWithSendCode {
    YOSUserForgetPassRequest *request = [[YOSUserForgetPassRequest alloc] initWithUsername:_phoneTextField.text];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusBadRequest errorBlock:^{
            [SVProgressHUD showErrorWithStatus:request.yos_baseResponseModel.msg maskType:SVProgressHUDMaskTypeClear];
        }];
        
        if ([request yos_checkResponse]) {
            
            _uid = request.yos_data[@"uid"];

            // 真机调试时候alert, 模拟器不alert
            if (TARGET_OS_IPHONE && [request.yos_data[@"code"] isKindOfClass:[NSString class]]) {
                [SVProgressHUD showInfoWithStatus:request.yos_data[@"code"]];
            } else {
                [SVProgressHUD showInfoWithStatus:@"验证码已发送，请查收~"];
            }
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

- (void)sendNetworkRequestWithUpdatePassword {
    
    if (!_uid.length) {
        [SVProgressHUD showErrorWithStatus:@"请先获取验证码哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    YOSUserUppwdByUnameRequest *request = [[YOSUserUppwdByUnameRequest alloc] initWithUid:_uid code:_verifyCodeTextField.text pwd1:_pwdTextField.text pwd2:_pwdTextField.text];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusBadRequest errorBlock:^{
            [SVProgressHUD showErrorWithStatus:request.yos_baseResponseModel.msg maskType:SVProgressHUDMaskTypeClear];
        }];
       
        if ([request yos_checkResponse]) {
            [SVProgressHUD showInfoWithStatus:@"修改密码成功~" maskType:SVProgressHUDMaskTypeClear];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 删除
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // tag = 0是手机号，最多输入11位字符
    if (textField.tag == 0 && textField.text.length >= 11) {
        return NO;
    }
    
    // tag = 1、2为输入验证码 输入最多6位
    if (textField.tag == 1 && textField.text.length >= 6) {
        return NO;
    }
    
    if (textField.tag == 2 && textField.text.length >= 20) {
        return NO;
    }
    
    return [YOSWidget validatePasswordWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)keyboardDidChangeFrame:(NSNotification *)noti {
    
    CGRect begin = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat scale = 1.0f;
    if (YOSIsIphone4) {
        scale = 0.5 / 5;
    } else if (YOSIsIphone5) {
        scale = 0.0 / 5;
    } else {
        scale = 0.0 / 5;
    }
    
    CGFloat transformY = (end.origin.y - begin.origin.y) * scale;
    
    CGFloat animationTime = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, transformY);
    }];
}

- (void)registerCodeBtnDisEnabled {
    self.registerCodeButton.enabled = NO;
    self.registerCodeButton.backgroundColor = YOSColorGray;
}

- (void)registerCodeBtnEnabled {
    self.registerCodeButton.enabled = YES;
    self.registerCodeButton.backgroundColor = YOSColorGreen;
}

- (void)changeTime {
    
    if (_timeCount > 1) {
        
        _timeCount--;
        [self.registerCodeButton setTitle:[NSString stringWithFormat:@"%zis后可重发", _timeCount] forState:UIControlStateDisabled];
        
    } else {
        [_timer invalidate];
        [self.registerCodeButton setTitle:[NSString stringWithFormat:@"%zis后可重发", kTimeMaxCount] forState:UIControlStateDisabled];
        
        [self registerCodeBtnEnabled];
    }
    
}

#pragma mark - event response

- (void)tappedRegisterButton {
    NSString *username = self.phoneTextField.text;
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (username.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号为11位哦~"];
        return;
    }
    
    if (self.registerCodeButton.enabled) {
        [self registerCodeBtnDisEnabled];
        
        [self.verifyCodeTextField becomeFirstResponder];
        
        // 发送验证码请求
        [self sendNetworkRequestWithSendCode];
        
        _timeCount = kTimeMaxCount;
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(changeTime) userInfo:nil repeats:kTimeMaxCount];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    [self.view endEditing:YES];
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
