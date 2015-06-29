//
//  YOSUpdateUserInfoViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUpdateUserInfoViewController.h"
#import "YOSSetHeadView.h"
#import "YOSInputView.h"
#import "YOSTextField.h"
#import "YOSIQContentView.h"

#import "YOSUserInfoModel.h"

#import "GVUserDefaults+YOSProperties.h"
#import "Masonry.h"
#import "XXNibConvention.h"
#import "YOSWidget.h"

@interface YOSUpdateUserInfoViewController ()

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@end

@implementation YOSUpdateUserInfoViewController {
    
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSSetHeadView *_setHeadView;
    
    YOSIQContentView *_iqContentView;
    YOSInputView *_inputView0;
    YOSInputView *_inputView1;
    YOSInputView *_inputView2;
    YOSInputView *_inputView3;
    YOSInputView *_inputView4;
    YOSInputView *_inputView5;
    YOSInputView *_inputView6;
    YOSInputView *_inputView7;
    YOSInputView *_inputView8;
    YOSInputView *_inputView9;
    NSMutableArray *_inputViews;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
    [self setupNavTitle:@"名片设置"];
    [self setupBackArrow];
    
    self.view.backgroundColor = YOSColorBackgroundGray;
}

- (void)setupSubviews {
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];

    _setHeadView = [YOSSetHeadView xx_instantiateFromNib];
    [_contentView addSubview:_setHeadView];
    
    _iqContentView = [YOSIQContentView new];
    [_contentView addSubview:_iqContentView];
    
    _inputView0 = [[YOSInputView alloc] initWithTitle:@"真实姓名" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView0.placeholder = @"请输入真实姓名";
    _inputView0.textField.text = self.userInfoModel.nickname;
    
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"手机号码" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView1.textField.text = [GVUserDefaults standardUserDefaults].currentLoginMobileNumber;
    _inputView1.placeholder = @"请输入手机号码";
    _inputView1.selected = YES;
    _inputView1.textField.userInteractionEnabled = NO;
    
    NSLog(@"userinfo %@", [GVUserDefaults standardUserDefaults].currentUserInfoDictionary);
    
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"邮箱地址" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView2.placeholder = @"请输入邮箱地址";
    _inputView2.textField.text = self.userInfoModel.email;
    
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"性别" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView3.placeholder = @"点击选择";
    _inputView3.pickerType = YOSInputViewPickerTypeSex;
    NSString *sex = nil;
    NSUInteger sexId = [self.userInfoModel.sex integerValue];
    if (sexId == 1) {
        sex = @"男";
    } else if (sexId == 2) {
        sex = @"女";
    } else {
        sex = @"";
    }
    _inputView3.textField.text = sex;
    
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"公司" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView4.placeholder = @"请输入公司";
    _inputView4.textField.text = self.userInfoModel.company;
    
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"公司电话" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView5.placeholder = @"请输入公司电话";
    _inputView5.textField.text = self.userInfoModel.phone;
    
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"公司网址" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView6.placeholder = @"请输入公司网址";
    _inputView6.textField.text = self.userInfoModel.website;
    
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"学历" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView7.placeholder = @"点击选择";
    _inputView7.pickerType = YOSInputViewPickerTypeEducation;
    
    _inputView8 = [[YOSInputView alloc] initWithTitle:@"工作经验" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView8.placeholder = @"点击选择";
    _inputView8.pickerType = YOSInputViewPickerTypeJobYears;
    
    _inputView9 = [[YOSInputView alloc] initWithTitle:@"诉求" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView9.placeholder = @"请输入您的诉求";
    
    _inputViews = [[NSMutableArray alloc] initWithArray:@[_inputView0,_inputView1,_inputView2,_inputView3,_inputView4,_inputView5,_inputView6,_inputView7,_inputView8,_inputView9]];
    
    [_inputViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [_iqContentView addSubview:obj];
    }];

    [self setupConstraints];
}

- (void)setupConstraints {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_inputView9.mas_bottom);
    }];
    
    [_setHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 75));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    [_iqContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_setHeadView.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_inputView8.mas_bottom);
    }];
    
    __block UIView *lastView = nil;
    [_inputViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(YOSScreenWidth);
                make.left.mas_equalTo(0);
            }];
        } else {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_bottom);
                make.width.mas_equalTo(YOSScreenWidth);
                make.left.mas_equalTo(0);
            }];
        }
        
        lastView = obj;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter

- (YOSUserInfoModel *)userInfoModel{
    if (!_userInfoModel) {
        _userInfoModel = [YOSWidget getCurrentUserInfoModel];
    }
    
    return _userInfoModel;
}

@end
