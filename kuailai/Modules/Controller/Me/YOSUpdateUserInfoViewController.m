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
#import "YOSUpdateUserInfoModel.h"

#import "YOSUserUpdateUserRequest.h"

#import "GVUserDefaults+YOSProperties.h"
#import "Masonry.h"
#import "XXNibConvention.h"
#import "YOSWidget.h"
#import "SVProgressHUD+YOSAdditions.h"

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
    YOSInputView *_inputView10;
    NSMutableArray *_inputViews;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
    [self setupNavTitle:@"名片设置"];
    [self setupBackArrow];
    
    [self setupRightButtonWithTitle:@"保存设置"];
    
    self.view.backgroundColor = YOSColorBackgroundGray;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressDidDisappear) name:SVProgressHUDDidDisappearNotification object:nil];
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
    _inputView0.selected = (BOOL)self.userInfoModel.nickname.length;
    
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"手机号码" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView1.textField.text = [GVUserDefaults standardUserDefaults].currentLoginMobileNumber;
    _inputView1.placeholder = @"请输入手机号码";
    _inputView1.selected = YES;
    _inputView1.textField.userInteractionEnabled = NO;
    
    NSLog(@"userinfo %@", [GVUserDefaults standardUserDefaults].currentUserInfoDictionary);
    
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"邮箱地址" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView2.placeholder = @"请输入邮箱地址";
    _inputView2.textField.text = self.userInfoModel.email;
    _inputView2.selected = (BOOL)self.userInfoModel.email.length;
    
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"性别" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView3.placeholder = @"点击选择";
    _inputView3.pickerType = YOSInputViewPickerTypeSex;
    _inputView3.textField.text = yos_getSex(self.userInfoModel.sex);
    _inputView3.sexId = ([self.userInfoModel.sex integerValue] ? self.userInfoModel.sex : nil);
    _inputView3.selected = (BOOL)self.userInfoModel.sex.integerValue;
    
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"公司" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView4.placeholder = @"请输入公司";
    _inputView4.textField.text = self.userInfoModel.company;
    _inputView4.selected = (BOOL)self.userInfoModel.company.length;
    
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"职位" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView5.placeholder = @"请输入职位";
    _inputView5.textField.text = self.userInfoModel.position;
    _inputView5.selected = (BOOL)self.userInfoModel.position.length;
    
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"公司电话" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView6.placeholder = @"请输入公司电话";
    _inputView6.textField.text = self.userInfoModel.tel;
    _inputView6.selected = (BOOL)self.userInfoModel.tel.length;
    
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"公司网址" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView7.placeholder = @"请输入公司网址";
    _inputView7.textField.text = self.userInfoModel.website;
    _inputView7.selected = (BOOL)self.userInfoModel.website.length;
    
    _inputView8 = [[YOSInputView alloc] initWithTitle:@"学历" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView8.placeholder = @"点击选择";
    _inputView8.pickerType = YOSInputViewPickerTypeEducation;
    _inputView8.textField.text = yos_getEducation(self.userInfoModel.degree);
    _inputView8.educationId = ([self.userInfoModel.degree integerValue] ? self.userInfoModel.degree : nil);
    _inputView8.selected = (BOOL)[self.userInfoModel.degree integerValue];
    
    _inputView9 = [[YOSInputView alloc] initWithTitle:@"工作经验" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView9.placeholder = @"点击选择";
    _inputView9.pickerType = YOSInputViewPickerTypeJobYears;
    _inputView9.textField.text = yos_getJobYears(self.userInfoModel.work_experience);
    _inputView9.jobYearsId = ([self.userInfoModel.work_experience integerValue] ? self.userInfoModel.work_experience : nil);
    _inputView9.selected = (BOOL)[self.userInfoModel.work_experience integerValue];
    
    _inputView10 = [[YOSInputView alloc] initWithTitle:@"诉求" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView10.placeholder = @"请输入您的诉求";
    _inputView10.textField.text = self.userInfoModel.demand;
    _inputView10.selected = (BOOL)self.userInfoModel.demand.length;
    
    _inputViews = [[NSMutableArray alloc] initWithArray:@[_inputView0,_inputView1,_inputView2,_inputView3,_inputView4,_inputView5,_inputView6,_inputView7,_inputView8,_inputView9,_inputView10]];
    
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
        make.bottom.mas_equalTo(_inputView10.mas_bottom);
    }];
    
    [_setHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 75));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    [_iqContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_setHeadView.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_inputView10.mas_bottom);
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event response

- (void)clickRightItem:(UIButton *)item {
    
    if (!_inputView0.selected || _inputView0.textWithoutWhitespace.length < 2) {
        [SVProgressHUD showErrorWithStatus:@"姓名必须填写哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    [self sendNetworkRequest];
}

//- (void)progressDidDisappear {
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - network

- (void)sendNetworkRequest {
    
    YOSUpdateUserInfoModel *updateModel = [YOSUpdateUserInfoModel new];
    
    updateModel.ID = [GVUserDefaults standardUserDefaults].currentLoginID;
    updateModel.nickname = YOSFliterNil2String(_inputView0.textWithoutWhitespace);
    updateModel.email = YOSFliterNil2String(_inputView2.text);
    updateModel.sex = YOSFliterNil2String(_inputView3.sexId);
    updateModel.company = YOSFliterNil2String(_inputView4.text);
    updateModel.position = YOSFliterNil2String(_inputView5.text);
    updateModel.tel = YOSFliterNil2String(_inputView6.text);
    updateModel.website = YOSFliterNil2String(_inputView7.text);
    updateModel.degrees = YOSFliterNil2String(_inputView8.educationId);
    updateModel.work_experience = YOSFliterNil2String(_inputView9.jobYearsId);
    updateModel.demand = YOSFliterNil2String(_inputView10.text);
    
    YOSUserUpdateUserRequest *request = [[YOSUserUpdateUserRequest alloc] initWithUpdateUserInfoModel:updateModel];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
           [SVProgressHUD showSuccessWithStatus:@"保存成功" maskType:SVProgressHUDMaskTypeClear];
        }];
        
        if ([request yos_checkResponse]) {
            NSMutableDictionary *mUserInfo = [[GVUserDefaults standardUserDefaults].currentUserInfoDictionary mutableCopy];
            mUserInfo[@"nickname"] = updateModel.nickname;
            mUserInfo[@"email"] = updateModel.email;
            mUserInfo[@"sex"] = updateModel.sex;
            mUserInfo[@"company"] = updateModel.company;
            mUserInfo[@"position"] = updateModel.position;
            mUserInfo[@"tel"] = updateModel.tel;
            mUserInfo[@"website"] = updateModel.website;
            mUserInfo[@"degress"] = updateModel.degrees;
            mUserInfo[@"work_experience"] = updateModel.work_experience;
            mUserInfo[@"demand"] = updateModel.demand;
            
            [GVUserDefaults standardUserDefaults].currentUserInfoDictionary = mUserInfo;
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationUpdateUserInfo object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - getter & setter

- (YOSUserInfoModel *)userInfoModel{
    if (!_userInfoModel) {
        _userInfoModel = [YOSWidget getCurrentUserInfoModel];
    }
    
    return _userInfoModel;
}

@end
