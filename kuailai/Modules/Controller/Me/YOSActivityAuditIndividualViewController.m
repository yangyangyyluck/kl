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

#import "Masonry.h"

@interface YOSActivityAuditIndividualViewController () <UICollectionViewDataSource, UICollectionViewDelegate>



@end

@implementation YOSActivityAuditIndividualViewController {
    YOSActivityAuditIndividualView *_aView;
    UICollectionView *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    [self setupNavTitle:@"审核报名"];
    
    _aView = [YOSActivityAuditIndividualView new];
    
    [self.view addSubview:_aView];
    
    [_aView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [self setupSubviews];
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
    return 20;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YOSAuditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YOSAuditCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

@end
