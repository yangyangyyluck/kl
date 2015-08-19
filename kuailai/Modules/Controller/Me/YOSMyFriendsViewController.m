//
//  YOSMyFriendsViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/5.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyFriendsViewController.h"
#import "YOSSendMessagesViewController.h"
#import "YOSUserInfoViewController.h"
#import "YOSFriendCell.h"

#import "YOSUserInfoModel.h"

#import "YOSUserGetUserByHxRequest.h"

#import "Masonry.h"
#import "YOSEaseMobManager.h"
#import "EMBuddy.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "YOSWidget.h"

@interface YOSMyFriendsViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *userInfoModels;

@property (nonatomic, strong) NSMutableArray *sectionsArray;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YOSMyFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupNavTitle:@"我的好友"];
    
    [self setupSubviews];
    
    [self sendNetworkRequest];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 70.0f;
    _tableView.sectionHeaderHeight = 25.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    
    return arr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionsArray[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSFriendCell *cell = [YOSFriendCell cellWithTableView:tableView];
    
    cell.userInfoModel = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) {
        cell.showTopLine = YES;
    } else {
        cell.showTopLine = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    YOSUserInfoModel *userInfoModel = self.dataSource[indexPath.section][indexPath.row];
    YOSUserInfoViewController *userVC = [YOSUserInfoViewController new];
    userVC.userInfoModel = userInfoModel;
    
    [self.navigationController pushViewController:userVC animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionsArray;
}

// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}

#pragma mark - network

- (void)sendNetworkRequest {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSArray *buddyList = [[YOSEaseMobManager sharedManager] getNewestBuddyList];
    
    NSMutableArray *hx_users = [NSMutableArray array];
    [buddyList enumerateObjectsUsingBlock:^(EMBuddy *obj, NSUInteger idx, BOOL *stop) {
        [hx_users addObject:obj.username];
    }];
    
    // 没有新信息
    if (!hx_users.count) {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        [self showDefaultMessage:@"目前还没有好友哦~" tappedBlock:nil isShowHUD:NO];
        return;
    } else {
        [self hideDefaultMessage];
    }
    
    YOSUserGetUserByHxRequest *request = [[YOSUserGetUserByHxRequest alloc] initWithHXUsers:hx_users];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            NSLog(@"%s", __func__);
            
            self.userInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:request.yos_data];
            
            [self.tableView reloadData];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];

}

#pragma mark - getter & setter 

- (void)setUserInfoModels:(NSMutableArray *)userInfoModels {
    _userInfoModels = userInfoModels;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [userInfoModels enumerateObjectsUsingBlock:^(YOSUserInfoModel *obj, NSUInteger idx, BOOL *stop) {
        
        NSString *pinyin = [YOSWidget pinyinTransformWithChinese:obj.nickname];
        
        if (pinyin) {
            NSString *firstAlphabet = [[pinyin uppercaseString] substringToIndex:1];
            
            if (![self.sectionsArray containsObject:firstAlphabet]) {
                
                NSString *alphabetTable = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                NSRange range = [alphabetTable rangeOfString:firstAlphabet];
                if (range.location != NSNotFound) {
                    [self.sectionsArray addObject:firstAlphabet];
                } else {
                    [self.sectionsArray addObject:@"#"];
                }
                
            }
            
            NSMutableArray *mArr = dict[firstAlphabet];
            if (!mArr) {
                mArr = [NSMutableArray array];
            }
            
            [mArr addObject:obj];
            
            dict[firstAlphabet] = mArr;
        }
        
    }];
    
    [self.sectionsArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    [self.sectionsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSArray *arr = dict[obj];
        [self.dataSource addObject:arr];
    }];
    
}

- (NSMutableArray *)sectionsArray {
    if (!_sectionsArray) {
        _sectionsArray = [NSMutableArray array];
    }
    
    return _sectionsArray;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}



@end
