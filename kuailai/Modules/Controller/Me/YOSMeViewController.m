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
#import "YOSBaseNavigationViewController.h"
#import "YOSTagEditViewController.h"
#import "YOSMyReleaseActivityViewController.h"
#import "YOSMyAttendActivityViewController.h"
#import "YOSSettingViewController.h"
#import "YOSLoginViewController.h"
#import "YOSTestViewController.h"
#import "YOSHeadDetailButton.h"
#import "YOSMeButtonView.h"
#import "YOSCellButton.h"
#import "YOSTapView.h"

#import "YOSUserInfoModel.h"
#import "YOSTagModel.h"

#import "YOSUserAddTagRequest.h"
#import "YOSUserGetTagListRequest.h"

#import "Masonry.h"
#import "XXNibBridge.h"
#import "YOSWidget.h"
#import "GVUserDefaults+YOSProperties.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "YOSEaseMobManager.h"

@interface YOSMeViewController ()

@property (nonatomic, strong) YOSUserInfoModel *userInfoModel;

@property (nonatomic, strong) NSArray *tags;

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
    
    YOSTapView *_tapView;
}

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"个人"];
    
    [self setupLeftButtonWithTitle:@"登录"];
    
    [self setupRightButtonWithTitle:@"设置"];
    
    if ([YOSWidget isLogin] && [YOSEaseMobManager sharedManager].isHxLogin) {
       
        [self sendNetworkRequest];
       
    } else {    // 未登录
        
        [self logout];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:YOSNotificationUpdateUserInfo object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagInfo) name:YOSNotificationUpdateUserInfo object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:YOSNotificationLogout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:YOSNotificationLogin object:nil];
    
}

- (void)setupSubviews {
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = YOSColorBackgroundGray;
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = YOSColorBackgroundGray;
    [_scrollView addSubview:_contentView];
    

    _headDetailButton = [[YOSHeadDetailButton alloc] initWithUserInfoModel:self.userInfoModel];
    [_headDetailButton addTarget:self action:@selector(tappedHeadDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:_headDetailButton];
    
    _meButtonView = [YOSMeButtonView xx_instantiateFromNib];
    [_contentView addSubview:_meButtonView];
    
    _cellButton0 = [[YOSCellButton alloc] initWithImage:@"我的邀请" title:@"发布的活动"];
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
    
    NSMutableArray *temp = [NSMutableArray array];
    
    [self.tags enumerateObjectsUsingBlock:^(YOSTagModel *obj, NSUInteger idx, BOOL *stop) {
        [temp addObject:obj.name];
    }];
    
    _tapView = [YOSTapView new];
    _tapView.tapArray = temp;
    
    [_contentView addSubview:_tapView];
 
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
        make.bottom.mas_equalTo(_tapView.mas_bottom);
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
    
    [_tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(_cellButtonTag.mas_bottom);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event response 

- (void)tappedCellButton:(YOSCellButton *)button {
    NSLog(@"%s", __func__);
    
    // 已发布的活动
    if (button.tag == 0) {
        YOSMyReleaseActivityViewController *releaseVC = [YOSMyReleaseActivityViewController new];
        [self.navigationController pushViewController:releaseVC animated:YES];
        return;
    }
    
    // 参与的活动
    if (button.tag == 1) {
        YOSMyAttendActivityViewController *attendVC = [YOSMyAttendActivityViewController new];
        [self.navigationController pushViewController:attendVC animated:YES];
        return;
    }
    
    // 你感兴趣的
    if (button.tag == 2) {
        
        return;
    }
}

- (void)tappedEditTagButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    
    YOSTagEditViewController *editVC = [YOSTagEditViewController new];
    
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)tappedHeadDetailButton:(YOSHeadDetailButton *)button {
    NSLog(@"%s", __func__);
    
    YOSUpdateUserInfoViewController *updateVC = [YOSUpdateUserInfoViewController new];
    
    [self.navigationController pushViewController:updateVC animated:YES];
}

- (void)clickLeftItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    
    YOSLoginViewController *loginVC = [YOSLoginViewController new];
    YOSBaseNavigationViewController *navVC = [[YOSBaseNavigationViewController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)clickRightItem:(UIButton *)item {
    NSLog(@"%s", __func__);
    
    YOSSettingViewController *settingVC = [YOSSettingViewController new];
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
    return;
    
    YOSTestViewController *testVC = [YOSTestViewController new];
    
    [self.navigationController pushViewController:testVC animated:YES];
    
    return;
    
    NSString *loginID = [GVUserDefaults standardUserDefaults].currentLoginID;
    
    NSString *username = [GVUserDefaults standardUserDefaults].currentLoginMobileNumber;
    
    NSString *loginID2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLoginID"];
    
    NSLog(@"\r\n\r\n id is : %@, id2 is : %@, username is %@", loginID, loginID2, username);
    
    return;
    
    YOSCreateActivityViewController *vc = [YOSCreateActivityViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network

- (void)sendNetworkRequest {
    NSLog(@"%s", __func__);
    
    NSDictionary *data = [GVUserDefaults standardUserDefaults].currentTagDictionary;
    
    
    // tag 数据从缓存中来
    if (data) {
        self.tags = [YOSTagModel arrayOfModelsFromDictionaries:data[@"data"]];
        [self setupSubviews];
        
        return;
    }
    
    YOSUserGetTagListRequest *request = [[YOSUserGetTagListRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            [GVUserDefaults standardUserDefaults].currentTagDictionary = request.yos_data;
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.tags = [YOSTagModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            
            [self setupSubviews];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - private method list

- (void)updateUserInfo {
    self.userInfoModel = [YOSWidget getCurrentUserInfoModel];
}

- (void)updateTagInfo {
    NSLog(@"%s", __func__);
    
    YOSUserGetTagListRequest *request = [[YOSUserGetTagListRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            [GVUserDefaults standardUserDefaults].currentTagDictionary = request.yos_data;
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.tags = [YOSTagModel arrayOfModelsFromDictionaries:request.yos_data[@"data"]];
            
            [_tapView updateTagInfo];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

- (void)login {
    _contentView.hidden = NO;

    [self hideDefaultMessage];
    [self sendNetworkRequest];
}

- (void)logout {
    _contentView.hidden = YES;
    
    YOSWSelf(weakSelf);
    [self showDefaultMessage:@"还未登录,点击登录" tappedBlock:^{
        
        YOSLoginViewController *loginVC = [YOSLoginViewController new];
        YOSBaseNavigationViewController *navVC = [[YOSBaseNavigationViewController alloc] initWithRootViewController:loginVC];
        
        [weakSelf presentViewController:navVC animated:YES completion:nil];
        
    }];
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
