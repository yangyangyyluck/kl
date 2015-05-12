//
//  YOSCreateActivityViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSCreateActivityViewController.h"
#import "YOSInputView.h"
#import "Masonry.h"
//#import "IQKeyboardManager.h"

@interface YOSCreateActivityViewController ()

@end

@implementation YOSCreateActivityViewController {
    
    // 容器view
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    // 容器1/2/3/4
    UIView *_firstContentView;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupBackArrow];
    [self setupNavTitle:@"发布活动"];
    self.view.backgroundColor = YOSRGB(238, 238, 238);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)setupSubviews {
    _scrollView = [UIScrollView new];
    _contentView = [UIView new];
    
    _firstContentView = [UIView new];
    _inputView0 = [[YOSInputView alloc] initWithTitle:@"活动标题:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView0.placeholder = @"最多25个字";
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"开始时间:" selectedStatus:NO maxCharacters:25 isSingleLine:NO];
    _inputView1.datePickerType = YOSInputViewDatePickerTypeActivity;
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"结束时间:" selectedStatus:NO maxCharacters:125 isSingleLine:YES];
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"报名截止:" selectedStatus:NO maxCharacters:125 isSingleLine:YES];
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"城市地区:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"活动地点:" selectedStatus:NO maxCharacters:125 isSingleLine:YES];
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"活动人数:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"人均费用:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    
    _inputViews = [NSMutableArray array];
    [_inputViews addObjectsFromArray:@[_inputView0, _inputView1, _inputView2, _inputView3, _inputView4, _inputView5, _inputView6, _inputView7]];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    [_contentView addSubview:_firstContentView];
    
//    [_firstContentView addSubview:_inputView0];
//    [_firstContentView addSubview:_inputView1];
//    [_firstContentView addSubview:_inputView2];
//    [_firstContentView addSubview:_inputView3];
//    [_firstContentView addSubview:_inputView4];
//    [_firstContentView addSubview:_inputView5];
//    [_firstContentView addSubview:_inputView6];
//    [_firstContentView addSubview:_inputView7];
    
    [_inputViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [_firstContentView addSubview:obj];
    }];

    _firstContentView.backgroundColor = YOSColorRandom;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [_scrollView addGestureRecognizer:tap];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
        make.bottom.mas_equalTo(_firstContentView.mas_bottom);
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
}

#pragma mark - touchEvent
- (void)click {
    NSLog(@"%s", __func__);
    YOSLog(@"%zi", _inputView0.text.length);
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
