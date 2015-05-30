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

@interface YOSCreateActivityViewController ()

@end

@implementation YOSCreateActivityViewController {
    
    // 容器view
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    // 容器1/2/3/4
    YOSIQContentView *_firstContentView;
    UIView *_secondContentView;
    UIView *_thirdContentView;
    UIView *_fourhContentView;
    
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
    
    [self setupSubviews];
    
    [self setupBackArrow];
    [self setupNavTitle:@"发布活动"];
    self.view.backgroundColor = YOSRGB(238, 238, 238);
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)setupSubviews {
    _scrollView = [UIScrollView new];
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
    
    // setup dataSource
    [self setupDataSource];
    [self setupActivityType];
    
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
//        [obj addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:@selector(nextAction:) doneAction:@selector(doneAction:)];
//        [obj setCustomPreviousTarget:self action:@selector(previousAction:)];
//        [obj setCustomNextTarget:self action:@selector(nextAction:)];
//        [obj setCustomDoneTarget:self action:@selector(doneAction:)];
//        [obj setEnablePrevious:NO next:YES];
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
    }];

    _thirdContentView = [UIView new];
    _activityCheckView = [YOSActivityCheckView new];

    [_thirdContentView addSubview:_activityCheckView];
    [_contentView addSubview:_thirdContentView];
    
    [_activityCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_thirdContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secondContentView.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_activityCheckView.mas_bottom);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_thirdContentView.mas_bottom);
    }];
}

#pragma mark - touchEvent
- (void)previousAction:(YOSInputView *)sender {
    if (sender.tag == 0) {
        [_inputView7 becomeFirstResponder];
    } else {
        [_inputViews[sender.tag] becomeFirstResponder];
    }
}

- (void)nextAction:(YOSInputView *)sender {
    if (sender.tag == 7) {
        [_inputView0 becomeFirstResponder];
    } else {
        [_inputViews[sender.tag] becomeFirstResponder];
    }
}

- (void)doneAction:(id)sender
{
    
    
    [self.view endEditing:YES];
}

- (void)click {

    
    [[YOSDBManager sharedManager] chooseTable:YOSDBManagerTableTypeCargoData isUseQueue:NO];
    
    NSArray *data = [[YOSDBManager sharedManager] getCargoDataWithKey:YOSDBTableCargoKeyTypeChooseCity];
    
    NSArray *arr = [YOSCityModel arrayOfModelsFromDictionaries:data];
    
    _inputView4.dataSource = arr;
    
    if (!data) {
        [self sendNetworkRequestGetCity];
    } else {
        _inputView4.dataSource = arr;
    }
    
    
}

- (void)setupDataSource {
    [[YOSDBManager sharedManager] chooseTable:YOSDBManagerTableTypeCargoData isUseQueue:NO];
    
    NSArray *data = [[YOSDBManager sharedManager] getCargoDataWithKey:YOSDBTableCargoKeyTypeChooseCity];
    
    NSArray *arr = [YOSCityModel arrayOfModelsFromDictionaries:data];
    
    if (!data) {
        [self sendNetworkRequestGetCity];
    } else {
        _inputView4.dataSource = arr;
    }
}

- (void)setupActivityType {
    
    [[YOSDBManager sharedManager] chooseTable:YOSDBManagerTableTypeCargoData isUseQueue:NO];
    
    NSArray *data = [[YOSDBManager sharedManager] getCargoDataWithKey:YOSDBTableCargoKeyTypeActivityType];
    
    NSArray *arr = [YOSActivityFatherTypeModel arrayOfModelsFromDictionaries:data];
    
    if (!data) {
        [self sendNetworkRequestGetType];
    } else {
        NSLog(@"%@", arr);
    }
    
}

#pragma mark - network

- (void)sendNetworkRequestGetCity {
    
    YOSActiveGetCityRequest *request = [[YOSActiveGetCityRequest alloc] initWithPid:@"0"];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            
            NSArray *arr = [YOSCityModel arrayOfModelsFromDictionaries:request.yos_data];
            
            _inputView4.dataSource = arr;
            
            [YOSDBManager setDataWithTable:YOSDBManagerTableTypeCargoData cargoDataKey:YOSDBTableCargoKeyTypeChooseCity cargoDataValue:request.yos_data];
            
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
            
            NSLog(@"%@", fatherModels);
        }
    } failure:^(YTKBaseRequest *request) {
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
