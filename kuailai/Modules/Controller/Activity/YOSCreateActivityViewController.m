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
#import "YOSIQContentView.h"
#import "YOSActivityPhotoView.h"
#import "YOSActivityCheckView.h"
#import "YOSActivityTypeView.h"

#import "YOSActiveGetCityRequest.h"
#import "YOSActiveGetTypeRequest.h"
#import "YOSUploadActivityImageRequest.h"
#import "YOSActiveInsertActiveRequest.h"
#import "YTKBatchRequest.h"

#import "YOSActivityFatherTypeModel.h"
#import "YOSSubmitInsetActiveModel.h"

#import "Masonry.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "YOSDBManager.h"
#import "YOSCityModel.h"
#import "XXNibConvention.h"
#import "YOSWidget.h"
#import "GVUserDefaults+YOSProperties.h"

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
    YOSInputView *_inputView8;
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
    self.view.backgroundColor = YOSColorBackgroundGray;
    
    [self setupRightButtonWithTitle:@"确认发布"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupSubviews {
    _scrollView = [UIScrollView new];
    _contentView = [UIView new];
    
    _firstContentView = [YOSIQContentView new];
    _inputView0 = [[YOSInputView alloc] initWithTitle:@"活动标题" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView0.placeholder = @"最多25个字";
    
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"开始时间" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView1.placeholder = @"点击选择";
    _inputView1.pickerType = YOSInputViewPickerTypeActivity;
    
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"结束时间" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView2.placeholder = @"点击选择";
    _inputView2.pickerType = YOSInputViewPickerTypeActivity;
    
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"报名截止" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView3.placeholder = @"点击选择";
    _inputView3.pickerType = YOSInputViewPickerTypeActivity;
    
    
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"城市地区" selectedStatus:NO maxCharacters:100 isSingleLine:YES];
    _inputView4.placeholder = @"点击选择";
    _inputView4.pickerType = YOSInputViewPickerTypeAllCity;
    _inputView4.dataSource = self.citys;
    
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"活动地点" selectedStatus:NO maxCharacters:200 isSingleLine:YES];
    _inputView5.placeholder = @"例：北京市海淀区中关村";
    
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"活动人数" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView6.placeholder = @"例：80人";
    _inputView6.keyboardType = UIKeyboardTypeNumberPad;
    
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"人均费用" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView7.placeholder = @"例：0元(免费)、100元等";
    _inputView7.keyboardType = UIKeyboardTypeDecimalPad;
    [_inputView7.textField setCustomNextTarget:self action:@selector(inputView7Next:)];
    
    _inputView8 = [[YOSInputView alloc] initWithTitle:@"活动详情" selectedStatus:NO maxCharacters:0 isSingleLine:NO];
    _inputView8.placeholder = @"活动详情、地点、事件等";
    
    
    _inputViews = [NSMutableArray array];
    [_inputViews addObjectsFromArray:@[_inputView0, _inputView1, _inputView2, _inputView3, _inputView4, _inputView5, _inputView6, _inputView7, _inputView8]];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    [_contentView addSubview:_firstContentView];
    
    [_inputViews enumerateObjectsUsingBlock:^(YOSInputView *obj, NSUInteger idx, BOOL *stop) {
        [_firstContentView addSubview:obj];
        obj.tag = idx;
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_firstContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_inputView8.mas_bottom);
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

- (void)inputView7Next:(YOSInputView *)inputView {
    NSLog(@"%s", __func__);
    [_inputView8 clickTextViewButton];
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
    
    if (!_inputView8.selected) {
        [SVProgressHUD showErrorWithStatus:@"请输入活动详情哦~" maskType:SVProgressHUDMaskTypeClear];
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

    self.submitInsetActiveModel.title = _inputView0.text;
    self.submitInsetActiveModel.start_time = [NSString stringWithFormat:@"%.0f", startTime];
    self.submitInsetActiveModel.end_time = [NSString stringWithFormat:@"%.0f", endTime];
    self.submitInsetActiveModel.close_time = [NSString stringWithFormat:@"%.0f", closeTime];
    self.submitInsetActiveModel.city = _inputView4.cityId;
    
    if (_inputView4.region) {
        self.submitInsetActiveModel.area = _inputView4.regionId;
    }
    
    self.submitInsetActiveModel.address = _inputView5.text;
    self.submitInsetActiveModel.num = _inputView6.text;
    self.submitInsetActiveModel.price = _inputView7.text;
    self.submitInsetActiveModel.type = _activityTypeView.type;
    self.submitInsetActiveModel.ctype = _activityTypeView.childType;
    
    // no detail
    self.submitInsetActiveModel.detail = _inputView8.text;
    
    self.submitInsetActiveModel.is_audit = _activityCheckView.isOpenCheck;
    self.submitInsetActiveModel.audit = _activityCheckView.checkField;
    self.submitInsetActiveModel.uid = [GVUserDefaults standardUserDefaults].currentLoginID;
    
    if (!_activityPhotoView.photos.count) {
        [SVProgressHUD showErrorWithStatus:@"请上传活动图片哦~" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    // ************ 上传图片 ************
    NSMutableArray *uploadRequests = [NSMutableArray array];
    
    [_activityPhotoView.photos enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
        YOSUploadActivityImageRequest *request = [[YOSUploadActivityImageRequest alloc] initWithImage:obj];
        
        [uploadRequests addObject:request];
        
    }];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:uploadRequests];
    
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        NSMutableArray *picList = [NSMutableArray array];
        
        __block BOOL canInsert = NO;
        [batchRequest.requestArray enumerateObjectsUsingBlock:^(YOSUploadActivityImageRequest *obj, NSUInteger idx, BOOL *stop) {
            
            [obj yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
                // do nothing..
                // so did not do [SVProgressHUD dismiss]
            }];
            
            if ([obj yos_checkResponse]) {
                // 第一个图片 放入 thumb 字段
                if (idx == 0) {
                    self.submitInsetActiveModel.thumb = obj.yos_data;
                    canInsert = YES;
                } else {    // 其他的放入picList 逗号分割
                    [picList addObject:obj.yos_data];
                }
            } else {
                // do nothing
            }
            
        }];
        
        if (picList.count) {
            NSString *picListString = [picList componentsJoinedByString:@","];
            self.submitInsetActiveModel.picList = picListString;
        }
        
        // 可以提交
        if (canInsert) {
            [self sendNetworkRequestInsertActive];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传图片失败,请重试~" maskType:SVProgressHUDMaskTypeClear];
        }
        
    } failure:^(YTKBatchRequest *batchRequest) {
        
        [SVProgressHUD showErrorWithStatus:@"上传图片失败,请重试~" maskType:SVProgressHUDMaskTypeClear];
        
        // do nothing..
    }];
    // ************ 上传图片 ************

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
            
            [[YOSDBManager sharedManager] setCargoKey:YOSDBTableCargoKeyTypeChooseCity cargoValue:request.yos_data];
            
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
            
            NSArray *fatherModels = [YOSActivityFatherTypeModel arrayOfModelsFromDictionaries:request.yos_data];
            
            [[YOSDBManager sharedManager] setCargoKey:YOSDBTableCargoKeyTypeActivityType cargoValue:request.yos_data];
            
            self.types = fatherModels;
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

- (void)sendNetworkRequestInsertActive {
    
    YOSLog(@"submitInsetActiveModel : %@", self.submitInsetActiveModel);
    
    YOSActiveInsertActiveRequest *request = [[YOSActiveInsertActiveRequest alloc] initWithModel:self.submitInsetActiveModel];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [request yos_performCustomResponseErrorWithStatus:BusinessRequestStatusSuccess errorBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"创建成功" maskType:SVProgressHUDMaskTypeClear];
        }];
        
        if ([request yos_checkResponse]) {
            YOSLog(@"\r\n\r\n inset active success..");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
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
