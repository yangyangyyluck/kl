//
//  YOSMeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMeViewController.h"
#import "YOSCreateActivityViewController.h"
#import "YOSHeadDetailButton.h"
#import "YOSMeButtonView.h"

#import "YOSUserInfoModel.h"

#import "Masonry.h"
#import "XXNibBridge.h"
#import "YOSWidget.h"

@interface YOSMeViewController ()

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@end

@implementation YOSMeViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YOSHeadDetailButton *_headDetailButton;
    YOSMeButtonView *_meButtonView;
}

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [_contentView addSubview:_headDetailButton];
    
    _meButtonView = [YOSMeButtonView xx_instantiateFromNib];
    [_contentView addSubview:_meButtonView];
 
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
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    
    YOSCreateActivityViewController *vc = [YOSCreateActivityViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter 

- (YOSUserInfoModel *)userInfoModel {
    if (!_userInfoModel) {
        NSDictionary *dict = [YOSWidget getUserDefaultWithKey:YOSUserDefaultKeyCurrentUserInfoDictionary];
        _userInfoModel = [[YOSUserInfoModel alloc] initWithDictionary:dict error:nil];
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
