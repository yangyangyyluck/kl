//
//  YOSMeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMeViewController.h"
#import "YOSCreateActivityViewController.h"
#import "YOSUpdateUserInfoViewController.h"
#import "YOSLoginViewController.h"
#import "YOSHeadDetailButton.h"
#import "YOSMeButtonView.h"
#import "YOSCellButton.h"

#import "YOSUserInfoModel.h"

#import "Masonry.h"
#import "XXNibBridge.h"
#import "YOSWidget.h"
#import "GVUserDefaults+YOSProperties.h"

@interface YOSMeViewController ()

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@end

@implementation YOSMeViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSHeadDetailButton *_headDetailButton;
    YOSMeButtonView *_meButtonView;
    
    YOSCellButton *_cellButton0;
    YOSCellButton *_cellButton1;
    YOSCellButton *_cellButton2;
    
    YOSCellButton *_cellButtonTag;
    UIButton *_editTagButton;
}

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"个人"];
    
    [self setupLeftButtonWithTitle:@"sasa"];
    
    [self setupRightButtonWithTitle:@"create"];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = YOSColorBackgroundGray;
    [_scrollView addSubview:_contentView];
    

    _headDetailButton = [[YOSHeadDetailButton alloc] initWithUserInfoModel:self.userInfoModel];
    [_headDetailButton addTarget:self action:@selector(tappedHeadDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_headDetailButton];
    
    _meButtonView = [YOSMeButtonView xx_instantiateFromNib];
    [_contentView addSubview:_meButtonView];
    
    _cellButton0 = [[YOSCellButton alloc] initWithImage:@"我的邀请" title:@"已发布的活动"];
    _cellButton0.showTopLine = YES;
    _cellButton0.tag = 0;
    [_cellButton0 addTarget:self action:@selector(tappedCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_cellButton0];
    
    _cellButton1 = [[YOSCellButton alloc] initWithImage:@"我的活动" title:@"参与的活动"];
    _cellButton1.tag = 1;
    [_cellButton1 addTarget:self action:@selector(tappedCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_cellButton1];
    
    _cellButton2 = [[YOSCellButton alloc] initWithImage:@"你感兴趣的" title:@"你感兴趣的"];
    _cellButton2.tag = 2;
    [_cellButton2 addTarget:self action:@selector(tappedCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_cellButton2];
    
    _cellButtonTag = [[YOSCellButton alloc] initWithImage:@"我的标签" title:@"我的标签"];
    _cellButtonTag.showTopLine = YES;
    _cellButtonTag.showRightAccessory = NO;
    
    [_contentView addSubview:_cellButtonTag];
    
    _editTagButton = [UIButton new];
    [_editTagButton setTitle:@"编辑标签" forState:UIControlStateNormal];
    _editTagButton.titleLabel.font = YOSFontSmall;
    [_editTagButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_editTagButton addTarget:self action:@selector(tappedEditTagButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cellButtonTag addSubview:_editTagButton];
 
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
    
    _headDetailButton.backgroundColor = YOSColorRandom;
    [_headDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
    }];
    
    [_meButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 70));
        make.top.mas_equalTo(_headDetailButton.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    [_cellButton0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_meButtonView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 44));
        make.left.mas_equalTo(0);
    }];
    
    [_cellButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cellButton0.mas_bottom);
        make.size.mas_equalTo(_cellButton0);
        make.left.mas_equalTo(0);
    }];
    
    [_cellButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cellButton1.mas_bottom);
        make.size.mas_equalTo(_cellButton0);
        make.left.mas_equalTo(0);
    }];
    
    [_cellButtonTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cellButton2.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(_cellButton0);
    }];
    
    [_editTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_cellButtonTag);
        make.size.mas_equalTo(CGSizeMake(50, 13));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response 

- (void)tappedCellButton:(YOSCellButton *)button {
    NSLog(@"%s", __func__);
    
    // 已发布的活动
    if (button.tag == 0) {
    
        return;
    }
    
    // 参与的活动
    if (button.tag == 1) {
        
        return;
    }
    
    // 你感兴趣的
    if (button.tag == 2) {
        
        return;
    }
}

- (void)tappedEditTagButton:(UIButton *)button {
    NSLog(@"%s", __func__);
}

- (void)tappedHeadDetailButton:(YOSHeadDetailButton *)button {
    NSLog(@"%s", __func__);
    
    YOSUpdateUserInfoViewController *updateVC = [YOSUpdateUserInfoViewController new];
    
    [self.navigationController pushViewController:updateVC animated:YES];
}

- (void)clickLeftItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    
    YOSLoginViewController *loginVC = [YOSLoginViewController new];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)clickRightItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    
    YOSCreateActivityViewController *vc = [YOSCreateActivityViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter & setter 

- (YOSUserInfoModel *)userInfoModel {
    if (!_userInfoModel) {
        _userInfoModel = [YOSWidget getCurrentUserInfoModel];
    }
    
    return _userInfoModel;
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
