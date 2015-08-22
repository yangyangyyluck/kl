//
//  YOSFindPassViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSFindPassViewController.h"

#import "YOSUserSendCodeRequest.h"

#import "YOSWidget.h"
#import "SVProgressHUD.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSFindPassViewController ()<UITextFieldDelegate>
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews {
    [self setupBackArrow];
    
    [self setupNavTitle:@"注册"];
    
    self.lineView0HeightConstraint.constant = 0.5;
    self.lineView1HeightConstraint.constant = 0.5;
    self.lineView2HeightConstraint.constant = 0.5;
    
    self.showPwdButton.layer.cornerRadius = 10;
    self.showPwdButton.layer.masksToBounds = YES;
    
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
    
    if (_verifyCodeTextField.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"验证码是6位哦~"];
        return;
    }
    
    if (_pwdTextField.text.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"密码最多20位哦~"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self sendNetworkRequest];
}

#pragma mark - network

- (void)sendNetworkRequest {
    YOSUserSendCodeRequest *request = [[YOSUserSendCodeRequest alloc] initWithPhoneNumber:_phoneTextField.text];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
       
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
            [SVProgressHUD showWithStatus:@"验证码已发送到您手机~"];
        }];
        
        if (![request yos_checkResponse]) {
            return;
        }
        
        // 真机调试时候alert, 模拟器不alert
        if (TARGET_OS_IPHONE && DEBUG && [request.yos_data[@"code"] isKindOfClass:[NSString class]]) {
            [SVProgressHUD showInfoWithStatus:request.yos_data[@"code"]];
        } else {
            [SVProgressHUD showInfoWithStatus:@"验证码已发送，请查收~"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
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
    
    // 删除
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // tag = 0是nickname，最多输入15位字符
    if (textField.tag == 0 && textField.text.length >= 15) {
        return NO;
    }
    
    // tag = 1、2为输入密码 输入最多20位
    if (textField.tag != 0 && textField.text.length >= 20) {
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
