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

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)setupSubviews {
    _scrollView = [UIScrollView new];
    _contentView = [UIView new];
    
    _firstContentView = [UIView new];
    _inputView0 = [[YOSInputView alloc] initWithTitle:@"活动标题:" selectedStatus:NO maxCharacters:25 isSingleLine:NO];
    _inputView0.placeholder = @"最多25个字";
    
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"开始时间:" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView1.placeholder = @"点击选择";
    _inputView1.pickerType = YOSInputViewPickerTypeAllCity;
    
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"结束时间:" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView2.placeholder = @"点击选择";
    _inputView2.pickerType = YOSInputViewPickerTypeActivity;
    
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"报名截止:" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    _inputView3.placeholder = @"点击选择";
    _inputView3.pickerType = YOSInputViewPickerTypeAge;
    
    
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"城市地区:" selectedStatus:NO maxCharacters:100 isSingleLine:YES];
    _inputView4.placeholder = @"点击选择";
    
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"活动地点:" selectedStatus:NO maxCharacters:125 isSingleLine:YES];
    _inputView5.placeholder = @"例：北京市海淀区中关村";
    
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"活动人数:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView6.placeholder = @"例：80人";
    
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"人均费用:" selectedStatus:NO maxCharacters:25 isSingleLine:YES];
    _inputView7.placeholder = @"例：0元(免费)、100元等";
    
    _inputViews = [NSMutableArray array];
    [_inputViews addObjectsFromArray:@[_inputView0, _inputView1, _inputView2, _inputView3, _inputView4, _inputView5, _inputView6, _inputView7]];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    [_contentView addSubview:_firstContentView];
    
    [_inputViews enumerateObjectsUsingBlock:^(YOSInputView *obj, NSUInteger idx, BOOL *stop) {
        [_firstContentView addSubview:obj];
        obj.tag = idx;
//        [obj addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:@selector(nextAction:) doneAction:@selector(doneAction:)];
        [obj setCustomPreviousTarget:self action:@selector(previousAction:)];
        [obj setCustomNextTarget:self action:@selector(nextAction:)];
        [obj setCustomDoneTarget:self action:@selector(doneAction:)];
//        [obj setEnablePrevious:NO next:YES];
    }];

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
    
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[YOSTextField class]];
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[YOSInputView class]];
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
    NSLog(@"%s", __func__);
    YOSLog(@"%zi", _inputView0.text.length);
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
