//
//  YOSLoginViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSLoginViewController.h"
#import "YOSRegisterViewController.h"

#import "YOSUserLoginRequest.h"

#import "YOSUserInfoModel.h"

#import "UIView+YOSAdditions.h"
#import "Masonry.h"
#import "YOSWidget.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"
#import "UIImage+YOSAdditions.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupSubviews {
    
    _closeButton = [UIButton new];
    [_closeButton addTarget:self action:@selector(tappedCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"白色关闭"] forState:UIControlStateNormal];
    
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
    _userTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    _passTextField.secureTextEntry = YES;
    [_passTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.view addSubview:_passTextField];
    
    _loginButton = [UIButton new];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 19.0f;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setBackgroundImage:[UIImage yos_imageWithColor:YOSColorGreen size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    
    [self.view addSubview:_loginButton];
    
    _registerButton = [UIButton new];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 19.0f;
    _registerButton.layer.masksToBounds = YES;
    [_registerButton setBackgroundImage:[UIImage yos_imageWithColor:YOSRGB(253, 135, 97) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
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
    
    CGFloat marginBottom = -75;
    if (YOSIsIphone6) {
        marginBottom = -155;
    }
    
    if (YOSIsIphone6P) {
        marginBottom = -185;
    }
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(_forgetButton.mas_top).offset(marginBottom);
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
    
    CGFloat marginTop = -75;
    if (YOSIsIphone4) {
        marginTop = -35;
    }
    
    if (YOSIsIphone5) {
        marginTop = -65;
    }
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_userTextField.mas_top).offset(marginTop);
        make.centerX.mas_equalTo(_registerButton);
    }];
    
//    _closeButton.backgroundColor = YOSColorRandom;
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
}

#pragma mark - event response

- (void)tappedLoginButton {
    NSLog(@"%s", __func__);
    
    NSString *user = _userTextField.text;
    if (user.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"输入手机号不正确哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    NSString *pass = _passTextField.text;
    if (!pass || pass.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码最少6位哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    [self sendNetworkRequest];
}

- (void)tappedRegisterButton {
    NSLog(@"%s", __func__);
    
    [self.navigationController pushViewController:[YOSRegisterViewController viewControllerFromStoryboardWithSBName:@"Register"] animated:YES];
}

- (void)tappedForgetButton {
    NSLog(@"%s", __func__);
}

- (void)tappedCloseButton {
    NSLog(@"%s", __func__);
    
    [UIView animateWithDuration:0.25f animations:^{
        _closeButton.transform=CGAffineTransformRotate(_closeButton.transform, -M_PI_2);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - network

- (void)sendNetworkRequest {
    
    YOSUserLoginRequest *request = [[YOSUserLoginRequest alloc] initWithUserName:_userTextField.text pwd:_passTextField.text models:[[UIDevice currentDevice] model]];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        if ([request yos_checkResponse]) {
            
//            [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentUserInfoDictionary value:request.yos_data];
            
            [GVUserDefaults standardUserDefaults].currentUserInfoDictionary = request.yos_data;
            
            
            YOSUserInfoModel *model = [[YOSUserInfoModel alloc] initWithDictionary:request.yos_data error:nil];
            
            if (model.ID) {
//                [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginID value:model.ID];
                [GVUserDefaults standardUserDefaults].currentLoginID = model.ID;
                YOSLog(@"\r\n\r\n had set LoginID");
            }
            
            if (model.username) {
//                [YOSWidget setUserDefaultWithKey:YOSUserDefaultKeyCurrentLoginMobileNumber value:model.username];
                [GVUserDefaults standardUserDefaults].currentLoginMobileNumber = model.username;
                YOSLog(@"\r\n\r\n had set LoginMobile");
            }
            
            [self tappedCloseButton];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [request yos_checkResponse];
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
