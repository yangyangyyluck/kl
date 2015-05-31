//
//  YOSCreateActivityViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSCreateActivityViewController.h"
#import "YOSInputView.h"
#import "YOSTextField.h"
#import "Masonry.h"
#import "SVProgressHUD+YOSAdditions.h"

#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "YOSActiveGetCityRequest.h"
#import "YOSActiveGetTypeRequest.h"
#import "YOSDBManager.h"
#import "YOSCityModel.h"
#import "YOSActivityFatherTypeModel.h"
#import "YOSIQContentView.h"
#import "YOSActivityPhotoView.h"
#import "XXNibConvention.h"
#import "YOSActivityCheckView.h"
#import "YOSActivityTypeView.h"
#import "YOSSubmitInsetActiveModel.h"

@interface YOSCreateActivityViewController ()

// 城市类型
@property (nonatomic, strong) NSArray *citys;

// 活动类型
@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) YOSSubmitInsetActiveModel *submitInsetActiveModel;

@end

@implementation YOSCreateActivityViewController {
    
    // 容器view
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    // 容器1/2/3/4
    YOSIQContentView *_firstContentView;
    UIView *_secondContentView;
    UIView *_thirdContentView;
    UIView *_fourthContentView;
    
    // firstContentView
    YOSInputView *_inputView0;
    YOSInputView *_inputView1;
    YOSInputView *_inputView2;
    YOSInputView *_inputView3;
    YOSInputView *_inputView4;
    YOSInputView *_inputView5;
    YOSInputView *_inputView6;
    YOSInputView *_inputView7;
    NSMutableArray *_inputViews;
    
    // _secondContentView
    YOSActivityPhotoView *_activityPhotoView;
    
    // _thirdContentView
    YOSActivityTypeView *_activityTypeView;
    
    // _fourthContentView
    YOSActivityCheckView *_activityCheckView;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self setupTypes];
    [self setupCitys];
    
    [self setupBackArrow];
    [self setupNavTitle:@"发布活动"];
    self.view.backgroundColor = YOSRGB(238, 238, 238);
    
    [self setupRightButtonWithTitle:@"确认发布"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupSubviews {
    _scrollView = [UIScrollView new];
    _scrollView.bounces = NO;
    _contentView = [UIView new];
    
    _firstContentView = [YOSIQContentView new];
    _inputView0 = [[YOSInputView alloc] initWithTitle:@"活动标题:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView0.placeholder = @"最多25个字";
    
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"开始时间:" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView1.placeholder = @"点击选择";
    _inputView1.pickerType = YOSInputViewPickerTypeActivity;
    
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"结束时间:" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView2.placeholder = @"点击选择";
    _inputView2.pickerType = YOSInputViewPickerTypeActivity;
    
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"报名截止:" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView3.placeholder = @"点击选择";
    _inputView3.pickerType = YOSInputViewPickerTypeActivity;
    
    
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"城市地区:" selectedStatus:NO maxCharacters:100 isSingleLine:YES];
    _inputView4.placeholder = @"点击选择";
    _inputView4.pickerType = YOSInputViewPickerTypeAllCity;
    _inputView4.dataSource = self.citys;
    
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"活动地点:" selectedStatus:NO maxCharacters:125 isSingleLine:YES];
    _inputView5.placeholder = @"例：北京市海淀区中关村";
    
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"活动人数:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView6.placeholder = @"例：80人";
    _inputView6.keyboardType = UIKeyboardTypeNumberPad;
    
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"人均费用:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView7.placeholder = @"例：0元(免费)、100元等";
    _inputView7.keyboardType = UIKeyboardTypeDecimalPad;
    
    _inputViews = [NSMutableArray array];
    [_inputViews addObjectsFromArray:@[_inputView0, _inputView1, _inputView2, _inputView3, _inputView4, _inputView5, _inputView6, _inputView7]];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    [_contentView addSubview:_firstContentView];
    
    [_inputViews enumerateObjectsUsingBlock:^(YOSInputView *obj, NSUInteger idx, BOOL *stop) {
        [_firstContentView addSubview:obj];
        obj.tag = idx;
    }];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
//    [_scrollView addGestureRecognizer:tap];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_firstContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_inputView7.mas_bottom);
    }];
    
    __block UIView *lastInputView = nil;
    [_inputViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        id temp = (lastInputView ? lastInputView.mas_bottom : @(0));
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(temp);
            make.height.mas_equalTo(44);
        }];
        
        lastInputView = obj;
    }];
    
    // second
    _secondContentView = [UIView new];
    [_contentView addSubview:_secondContentView];
    
    _activityPhotoView = [YOSActivityPhotoView xx_instantiateFromNib];
    
    [_secondContentView addSubview:_activityPhotoView];
    
    [_secondContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_firstContentView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 120));
    }];
    
    [_activityPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_secondContentView).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    // third
    _thirdContentView = [UIView new];
    _activityTypeView = [[YOSActivityTypeView alloc] initWithActivityFatherTypeModels:self.types];
    
    YOSWSelf(weakSelf);
    YOSWObject(_activityTypeView, weakActivityTypeView);
    _activityTypeView.vBlock = ^{
        
        CGFloat height = weakActivityTypeView.currentHeight;
        [weakActivityTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        
        [weakSelf.view layoutIfNeeded];
        
    };
    
    [_thirdContentView addSubview:_activityTypeView];
    [_contentView addSubview:_thirdContentView];
    
    CGFloat height = _activityTypeView.currentHeight;
    [_activityTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_thirdContentView).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.height.mas_equalTo(height);
    }];
    
    [_thirdContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secondContentView.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(_activityTypeView);
    }];

    // fourth
    _fourthContentView = [UIView new];
    _activityCheckView = [YOSActivityCheckView new];

    [_fourthContentView addSubview:_activityCheckView];
    [_contentView addSubview:_fourthContentView];
    
    CGFloat checkHeight = _activityCheckView.currentHeight;
    [_activityCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_fourthContentView).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.height.mas_equalTo(checkHeight);
    }];
    
    [_fourthContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_thirdContentView.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(_activityCheckView);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_fourthContentView.mas_bottom);
    }];
}

#pragma mark - event response

- (void)click {
    NSLog(@"%s", __func__);
}

- (void)clickRightItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    
    
    if (!_inputView0.selected) {
        [SVProgressHUD showErrorWithStatus:@"请输入活动标题哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView1.selected) {
        [SVProgressHUD showErrorWithStatus:@"请选择开始时间哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView2.selected) {
        [SVProgressHUD showErrorWithStatus:@"请选择结束时间哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView3.selected) {
        [SVProgressHUD showErrorWithStatus:@"请选择报名截止时间哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView4.selected) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市地区哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView5.selected) {
        [SVProgressHUD showErrorWithStatus:@"请输入活动地点哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView6.selected) {
        [SVProgressHUD showErrorWithStatus:@"请输入活动人数哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (!_inputView7.selected) {
        [SVProgressHUD showErrorWithStatus:@"请输入人均费用哦(免费填0)~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    
    
    NSDate *startDate = _inputView1.date;
    NSDate *endDate = _inputView2.date;
    NSDate *closeDate = _inputView3.date;
    
    NSTimeInterval startTime = startDate.timeIntervalSince1970;
    NSTimeInterval endTime = endDate.timeIntervalSince1970;
    NSTimeInterval closeTime = closeDate.timeIntervalSince1970;
    
    if (startTime >= endTime) {
        [SVProgressHUD showErrorWithStatus:@"活动开始时间必须小于结束时间哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (closeTime >= startTime) {
        [SVProgressHUD showErrorWithStatus:@"报名截止时间必须小于活动开始时间哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    NSLog(@"%f, %f, %f", startTime, endTime, closeTime);

    
    if (!_activityPhotoView.photos.count) {
        [SVProgressHUD showErrorWithStatus:@"请上传活动图片哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    
    self.submitInsetActiveModel.title = _inputView0.text;
    self.submitInsetActiveModel.start_time = [NSString stringWithFormat:@"%.0f", startTime];
    self.submitInsetActiveModel.end_time = [NSString stringWithFormat:@"%.0f", endTime];
    self.submitInsetActiveModel.close_time = [NSString stringWithFormat:@"%.0f", closeTime];
    self.submitInsetActiveModel.city = _inputView4.city;

    if (_inputView4.region) {
        self.submitInsetActiveModel.area = _inputView4.region;
    }
    
    self.submitInsetActiveModel.address = _inputView5.text;
    self.submitInsetActiveModel.num = _inputView6.text;
    self.submitInsetActiveModel.price = _inputView7.text;
    self.submitInsetActiveModel.type = _activityTypeView.type;
    self.submitInsetActiveModel.ctype = _activityTypeView.childType;
    
    // no detail
    
    self.submitInsetActiveModel.is_audit = _activityCheckView.isOpenCheck;
    self.submitInsetActiveModel.audit = _activityCheckView.checkField;
    
    YOSLog(@"%@", self.submitInsetActiveModel);
}

#pragma mark - private methods

- (void)setupCitys {
    
    NSArray *data = [[YOSDBManager sharedManager] getCargoDataWithKey:YOSDBTableCargoKeyTypeChooseCity];
    
    NSArray *arr = [YOSCityModel arrayOfModelsFromDictionaries:data];
    
    if (!data) {
        [self sendNetworkRequestGetCity];
    } else {
        self.citys = arr;
    }
}

- (void)setupTypes {
    
    NSArray *data = [[YOSDBManager sharedManager] getCargoDataWithKey:YOSDBTableCargoKeyTypeActivityType];
    
    NSArray *arr = [YOSActivityFatherTypeModel arrayOfModelsFromDictionaries:data];
    
    if (!data) {
        [self sendNetworkRequestGetType];
    } else {
        NSLog(@"%@", arr);
        self.types = arr;
    }
    
}

#pragma mark - network

- (void)sendNetworkRequestGetCity {
    
    YOSActiveGetCityRequest *request = [[YOSActiveGetCityRequest alloc] initWithPid:@"0"];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            
            NSArray *arr = [YOSCityModel arrayOfModelsFromDictionaries:request.yos_data];
            
            [YOSDBManager setDataWithTable:YOSDBManagerTableTypeCargoData cargoDataKey:YOSDBTableCargoKeyTypeChooseCity cargoDataValue:request.yos_data];
            
            self.citys = arr;
            
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];

}

- (void)sendNetworkRequestGetType {
    NSLog(@"%s", __func__);
    
    YOSActiveGetTypeRequest *request2 = [[YOSActiveGetTypeRequest alloc] initWithPid:@"0"];
    
    [request2 startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            [YOSDBManager setDataWithTable:YOSDBManagerTableTypeCargoData cargoDataKey:YOSDBTableCargoKeyTypeActivityType cargoDataValue:request.yos_data];
            
            NSArray *fatherModels = [YOSActivityFatherTypeModel arrayOfModelsFromDictionaries:request.yos_data];
            
            self.types = fatherModels;
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - getter & setter

- (void)setCitys:(NSArray *)citys {
    _citys = citys;
    
    if (_citys && _types) {
        [SVProgressHUD dismiss];
        [self setupSubviews];
    }
}

- (void)setTypes:(NSArray *)types {
    _types = types;
    
    if (_citys && _types) {
        [SVProgressHUD dismiss];
        [self setupSubviews];
    }
}

- (YOSSubmitInsetActiveModel *)submitInsetActiveModel {
    if (!_submitInsetActiveModel) {
        _submitInsetActiveModel = [YOSSubmitInsetActiveModel new];
    }
    
    return _submitInsetActiveModel;
}

@end
