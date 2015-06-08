//
//  YOSRegStepTwoViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSRegStepTwoViewController.h"

#import "YOSAccessoryView.h"

#import "YOSUserRegisterRequest.h"

#import "YOSWidget.h"
#import "SVProgressHUD.h"

@interface YOSRegStepTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView0HeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwd1TextField;
@property (weak, nonatomic) IBOutlet UITextField *pwd2TextField;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation YOSRegStepTwoViewController {
    YOSAccessoryView *_accessoryView0;
    YOSAccessoryView *_accessoryView1;
    YOSAccessoryView *_accessoryView2;
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
    
    YOSWSelf(weakSelf);
    YOSAccessoryView *accessoryView0 = [[YOSAccessoryView alloc] initWithDefaultPlaceBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    [accessoryView0 buttonWithTitle:@"下一行" target:weakSelf method:@selector(nextStep0) position:YOSAccessoryViewPositionRight];
    
    _accessoryView0 = accessoryView0;
    self.nickNameTextField.inputAccessoryView = accessoryView0;
    
    
    YOSAccessoryView *accessoryView1 = [[YOSAccessoryView alloc] initWithDefaultPlaceBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    [accessoryView1 buttonWithTitle:@"下一行" target:weakSelf method:@selector(nextStep1) position:YOSAccessoryViewPositionRight];
    [accessoryView1 buttonWithTitle:@"上一行" target:weakSelf method:@selector(previousStep1) position:YOSAccessoryViewPositionLeft];
    
    _accessoryView1 = accessoryView1;
    self.pwd1TextField.inputAccessoryView = accessoryView1;
    
    YOSAccessoryView *accessoryView2 = [[YOSAccessoryView alloc] initWithDefaultPlaceBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    [accessoryView2 buttonWithTitle:@"上一行" target:weakSelf method:@selector(previousStep2) position:YOSAccessoryViewPositionLeft];
    [accessoryView2 buttonWithTitle:@"确定" target:weakSelf method:@selector(clickSureButton:) position:YOSAccessoryViewPositionRight];
    
    _accessoryView2 = accessoryView2;
    self.pwd2TextField.inputAccessoryView = accessoryView2;
}

#pragma mark - touch event
- (void)nextStep0 {
    NSLog(@"%s", __func__);
    [_pwd1TextField becomeFirstResponder];
}

- (void)nextStep1 {
    NSLog(@"%s", __func__);
    [_pwd2TextField becomeFirstResponder];
}

- (void)previousStep1 {
    NSLog(@"%s", __func__);
    [_nickNameTextField becomeFirstResponder];
}

- (void)previousStep2 {
    NSLog(@"%s", __func__);
    [_pwd1TextField becomeFirstResponder];
}

- (IBAction)clickShowButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
    if ([sender.currentTitle isEqualToString:@"显示密码"]) {
        [sender setTitle:@"隐藏密码" forState:UIControlStateNormal];
        _pwd1TextField.secureTextEntry = NO;
        _pwd2TextField.secureTextEntry = NO;
    } else {
        [sender setTitle:@"显示密码" forState:UIControlStateNormal];
        _pwd1TextField.secureTextEntry = YES;
        _pwd2TextField.secureTextEntry = YES;
    }
}

- (IBAction)clickSureButton:(UIButton *)sender {
    NSLog(@"%s", __func__);
    
    if (_nickNameTextField.text.length < 2) {
        [SVProgressHUD showErrorWithStatus:@"昵称最少2位哦~"];
        return;
    }
    
    if (_pwd1TextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码最少6位哦~"];
        return;
    }
    
    if (_pwd1TextField.text.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"密码最多20位哦~"];
        return;
    }
    
    if (![_pwd1TextField.text isEqualToString:_pwd2TextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致~"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSString *username = _nickNameTextField.text;
    NSString *ID = [YOSWidget getUserDefaultWithKey:YOSUserDefaultKeyCurrentRegisterID];
    
    YOSUserRegisterRequest *request = [[YOSUserRegisterRequest alloc] initWithUserName:username ID:ID password1:_pwd1TextField.text password2:_pwd2TextField.text];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (![request yos_checkResponse]) {
            return;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"ok!"];
        
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
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
