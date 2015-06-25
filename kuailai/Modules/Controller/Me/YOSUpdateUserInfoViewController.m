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

#import "GVUserDefaults+YOSProperties.h"
#import "Masonry.h"
#import "XXNibConvention.h"

@interface YOSUpdateUserInfoViewController ()

@end

@implementation YOSUpdateUserInfoViewController {
    
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSSetHeadView *_setHeadView;
    
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
    
    _inputView0 = [[YOSInputView alloc] initWithTitle:@"真实姓名" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView1 = [[YOSInputView alloc] initWithTitle:@"手机号码" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView2 = [[YOSInputView alloc] initWithTitle:@"邮箱地址" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView3 = [[YOSInputView alloc] initWithTitle:@"性别" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView4 = [[YOSInputView alloc] initWithTitle:@"公司" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView5 = [[YOSInputView alloc] initWithTitle:@"公司电话" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView6 = [[YOSInputView alloc] initWithTitle:@"公司网址" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView7 = [[YOSInputView alloc] initWithTitle:@"学历" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputView8 = [[YOSInputView alloc] initWithTitle:@"工作经验" selectedStatus:NO maxCharacters:0 isSingleLine:YES];
    
    _inputViews = [[NSMutableArray alloc] initWithArray:@[_inputView0,_inputView1,_inputView2,_inputView3,_inputView4,_inputView5,_inputView6,_inputView7,_inputView8]];
    
    [_inputViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:obj];
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
        make.height.mas_equalTo(YOSScreenHeight * 3);
    }];
    
    [_setHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 75));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    __block UIView *lastView = nil;
    [_inputViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_setHeadView.mas_bottom).offset(10);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
