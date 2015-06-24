//
//  YOSUpdateUserInfoViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSUpdateUserInfoViewController.h"
#import "YOSSetHeadView.h"

#import "GVUserDefaults+YOSProperties.h"
#import "Masonry.h"
#import "XXNibConvention.h"

@interface YOSUpdateUserInfoViewController ()

@end

@implementation YOSUpdateUserInfoViewController {
    
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSSetHeadView *_setHeadView;
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
        make.top.and.left.mas_equalTo(0);
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
