//
//  YOSLoginViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSLoginViewController.h"

#import "UIView+YOSAdditions.h"
#import "Masonry.h"

@interface YOSLoginViewController ()

@end

@implementation YOSLoginViewController {
    
    UIButton *_closeButton;
    
    UILabel *_titleLabel;
    UITextField *_userTextField;
    UITextField *_passTextField;
    
    UIButton *_loginButton;
    UIButton *_registerButton;
    
    UIButton *_forgetButton;
    UIImageView *_arrowImageView;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = YOSColorMainRed;
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _closeButton = [UIButton new];
    [_closeButton addTarget:self action:@selector(tappedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    
    [self.view addSubview:_closeButton];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:45.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"Welcome";
    
    [self.view addSubview:_titleLabel];
    
    _userTextField = [UITextField new];
    _userTextField.font = [UIFont systemFontOfSize:15.0];
    _userTextField.textColor = [UIColor whiteColor];
    _userTextField.textAlignment = NSTextAlignmentCenter;
    _userTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    _userTextField.layer.borderWidth = 0.5;
    _userTextField.layer.cornerRadius = 19.0f;
    _userTextField.layer.masksToBounds = YES;
    _userTextField.placeholder = @"请输入账号";
    [_userTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.view addSubview:_userTextField];
    
    _passTextField = [UITextField new];
    _passTextField.font = [UIFont systemFontOfSize:15.0];
    _passTextField.textColor = [UIColor whiteColor];
    _passTextField.textAlignment = NSTextAlignmentCenter;
    _passTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    _passTextField.layer.borderWidth = 0.5;
    _passTextField.layer.cornerRadius = 19.0f;
    _passTextField.layer.masksToBounds = YES;
    _passTextField.placeholder = @"请输入密码";
    [_passTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.view addSubview:_passTextField];
    
    _loginButton = [UIButton new];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 19.0f;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.backgroundColor = YOSColorGreen;
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    
    [self.view addSubview:_loginButton];
    
    _registerButton = [UIButton new];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 19.0f;
    _registerButton.layer.masksToBounds = YES;
    _registerButton.backgroundColor = YOSRGB(253, 135, 97);
    _registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];

    [self.view addSubview:_registerButton];
    
    _forgetButton = [UIButton new];
    [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [_forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_forgetButton];
    
    _arrowImageView = [UIImageView new];
    _arrowImageView.image = [UIImage imageNamed:@"小箭头"];
    
    [self.view addSubview:_arrowImageView];
    
    [_loginButton addTarget:self action:@selector(tappedLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton addTarget:self action:@selector(tappedRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [_forgetButton addTarget:self action:@selector(tappedForgetButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    // bottom 开始布局
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
    
    [_forgetButton sizeToFit];
    [_forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_arrowImageView.mas_left).offset(-8);
        make.centerY.mas_equalTo(_arrowImageView);
    }];
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(_forgetButton.mas_top).offset(-75);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_registerButton);
        make.centerX.mas_equalTo(_registerButton);
        make.bottom.mas_equalTo(_registerButton.mas_top).offset(-30);
    }];
    
    [_passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_registerButton);
        make.centerX.mas_equalTo(_registerButton);
        make.bottom.mas_equalTo(_loginButton.mas_top).offset(-15);
    }];
    
    [_userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_registerButton);
        make.centerX.mas_equalTo(_registerButton);
        make.bottom.mas_equalTo(_passTextField.mas_top).offset(-15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_userTextField.mas_top).offset(-65);
        make.centerX.mas_equalTo(_registerButton);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(30);
    }];
}

#pragma mark - event response

- (void)tappedLoginButton {
    NSLog(@"%s", __func__);
}

- (void)tappedRegisterButton {
    NSLog(@"%s", __func__);
}

- (void)tappedForgetButton {
    NSLog(@"%s", __func__);
}

- (void)tappedCloseButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    
    [UIView animateWithDuration:0.25f animations:^{
        button.transform=CGAffineTransformRotate(button.transform, -M_PI_2);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
