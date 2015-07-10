//
//  YOSActivityAuditIndividualViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityAuditIndividualViewController.h"
#import "YOSActivityAuditIndividualView.h"
#import "YOSAuditCollectionViewCell.h"

#import "YOSUserInfoModel.h"

#import "YOSActiveGetSignUpRequest.h"

#import "Masonry.h"
#import "SVProgressHUD+YOSAdditions.h"

@interface YOSActivityAuditIndividualViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 当前偏移量，用于计算是像左还是向右滚动 */
@property (nonatomic, assign) CGPoint currentOffset;

/** 标志位：当前是向左滚动还是向右，影响发送网络请求时的page参数 */
@property (nonatomic, assign) BOOL isScrollLeft;

/** 标识位：需要发送网络请求 */
@property (nonatomic, assign) BOOL isNeedSendNetworkRequest;

@end

@implementation YOSActivityAuditIndividualViewController {
    UICollectionView *_collectionView;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    [self setupNavTitle:@"审核报名"];
    
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    self.currentOffset = _collectionView.contentOffset;
}

- (void)dealloc {
    YOSLog(@"\r\n\r\nYOSActivityAuditIndividualViewController dealloc");
}

- (void)setupSubviews {
    // ------轮播页------
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(YOSScreenWidth, YOSScreenHeight - 64.0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[YOSAuditCollectionViewCell class] forCellWithReuseIdentifier:@"YOSAuditCollectionViewCell"];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSArray *array = self.userInfoModels[section];
    
    // 伪造 1 条数据
    // 在新的section - item 中请求数据 再reloadData
    return (array.count ? array.count : 1);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.userInfoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSAuditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YOSAuditCollectionViewCell" forIndexPath:indexPath];
    
    NSArray *subUserInfoModels = self.userInfoModels[indexPath.section];
    YOSUserInfoModel *userInfoModel = nil;
    
    // 该数据实际还没有
    // 在新的 item 中请求数据 再reloadData
    if (subUserInfoModels.count >= (indexPath.item + 1)) {
        userInfoModel = subUserInfoModels[indexPath.item];
    } else {
        self.isNeedSendNetworkRequest = YES;
    }
    
    cell.userInfoModel = userInfoModel;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"offset :%@ -- ", NSStringFromCGPoint(scrollView.contentOffset));
    if (self.currentOffset.x < scrollView.contentOffset.x) {
        self.isScrollLeft = NO;
    } else {
        self.isScrollLeft = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendNetworkRequest];
}

#pragma mark - network

- (void)sendNetworkRequest {
    
    if (!self.isNeedSendNetworkRequest) {
        return;
    } else {
        self.isNeedSendNetworkRequest = NO;
    }
    
    NSUInteger page = 0;
    if (self.isScrollLeft) {
        page = self.currentIndexPath.section;
    } else {
        page = self.currentIndexPath.section + 2;
    }
    
    YOSActiveGetSignUpRequest *request = [[YOSActiveGetSignUpRequest alloc] initWithAid:self.aid andPage:[NSString stringWithFormat:@"%zi", page]];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        if ([request yos_checkResponse]) {
            
            NSArray *array = request.yos_data[@"data"];
            
            if (!array.count) {
                return;
            }
            
            NSArray *subUserInfoModels = [YOSUserInfoModel arrayOfModelsFromDictionaries:array];
            
            self.userInfoModels[page - 1] = subUserInfoModels;
            
            NSLog(@"activity list, subUserInfoModels : %@", subUserInfoModels);
            
            NSUInteger item = 0;
            if (self.isScrollLeft) {
                item = subUserInfoModels.count - 1;
            } else {
                item = 0;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:page - 1];
            self.currentIndexPath = indexPath;
            
            YOSLog(@"currentIndexPath : %@", self.currentIndexPath);
            
            [_collectionView reloadData];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [request yos_checkResponse];
    }];
}

#pragma mark - getter & setter

- (void)setUserInfoModels:(NSMutableArray *)userInfoModels {
    _userInfoModels = userInfoModels;
    
//    [_collectionView reloadData];
//    [_collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

@end
