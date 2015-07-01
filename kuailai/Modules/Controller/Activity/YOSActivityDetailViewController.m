//
//  YOSActivityDetailViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityDetailViewController.h"
#import "YOSAttentionUserViewController.h"
#import "YOSLoginViewController.h"
#import "YOSBaseNavigationViewController.h"
#import "YOSUpdateUserInfoViewController.h"
#import "YOSActivityDetailItemView.h"
#import "YOSCollectionImageCell.h"
#import "YOSDetailLabel.h"
#import "YLLabel.h"
#import "YOSNeedView.h"
#import "YOSFriendCell.h"


#import "YOSActiveGetActiveRequest.h"
#import "YOSActiveSignUpRequest.h"
#import "YOSActiveIsSignUpRequest.h"

#import "YOSActivityDetailModel.h"
#import "YOSUserInfoModel.h"
#import "YOSFriendModel.h"

#import "Masonry.h"
#import "EDColor.h"
#import "YOSWidget.h"
#import "UIView+YOSAdditions.h"
#import "SVProgressHUD+YOSAdditions.h"
#import "GVUserDefaults+YOSProperties.h"
#import "UIImage+YOSAdditions.h"

static const NSUInteger numbersOfSections = 100;

@interface YOSActivityDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, strong) YOSActivityDetailModel *activityDetailModel;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSArray *friends;

@property (nonatomic, strong) NSArray *signConditions;

@end

@implementation YOSActivityDetailViewController {
    
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    // 轮播页
    UIView *_collectionContainterView;
    UICollectionView *_collectionView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    
    // title
    UILabel *_titleLabel;
    
    // list
    UIView *_listView;
    NSMutableArray *_lists;
    
    // 活动介绍
    UILabel *_introduceLabel;
    
    // 活动详情
    UIView *_introduceDetailView;
    YLLabel *_introduceDetailLabel;
    
    // 报名所需资料
    UILabel *_needLabel;
    
    // 资料按钮
    UIView *_needContainerView;
    YOSNeedView *_needDetailView;
    
    // 他们都关注了
    UILabel *_noticeLabel;
    UIButton *_originatorView;
    UILabel *_originatorLabel;
    UILabel *_originatorNameLabel;
    UIImageView *_rightArrowImageView;
    
    UITableView *_tableView;
    UIButton *_moreUserButton;
    UIButton *_signButton;
}

- (instancetype)initWithActivityId:(NSString *)activityId {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityId = activityId;
    
    return self;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"活动详情"];
    
    [self setupBackArrow];
    
    self.view.backgroundColor = YOSColorBackgroundGray;
    
    [self sendNetworkRequest];
}

- (void)setupSubviews {
    
    _scrollView = [UIScrollView new];
    _contentView = [UIView new];
    _scrollView.backgroundColor = YOSColorBackgroundGray;
    _contentView.backgroundColor = YOSColorBackgroundGray;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    
    // ------轮播页------
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // 1000 x 350
    // 320 x 112
    layout.itemSize = CGSizeMake(YOSScreenWidth, YOSAutolayout(112));
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    // 只有1张图片时 不轮播
    _collectionView.scrollEnabled = (self.images.count > 1 ? YES : NO);
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[YOSCollectionImageCell class] forCellWithReuseIdentifier:@"YOSCollectionImageCell"];
    
    _collectionContainterView = [UIView new];
    [_contentView addSubview:_collectionContainterView];
    [_collectionContainterView addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = self.images.count;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = YOSColorMainRed;
    _pageControl.enabled = NO;
    _pageControl.hidesForSinglePage = YES;
    [_collectionContainterView addSubview:_pageControl];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = YOSFontBig;
    _titleLabel.textColor = YOSColorFontBlack;
    _titleLabel.text = self.activityDetailModel.title;
    _titleLabel.backgroundColor = YOSColorBackgroundGray;
    [_contentView addSubview:_titleLabel];
    
    _listView = [UIView new];
    _listView.layer.borderColor = YOSColorLineGray.CGColor;
    _listView.layer.borderWidth = 0.5;
    [_contentView addSubview:_listView];
    _lists = [NSMutableArray array];
    
    NSString *time = [NSString stringWithFormat:@"%@ 至 %@", [YOSWidget dateStringWithTimeStamp:self.activityDetailModel.start_time Format:@"MM-dd EEEE HH:mm"], [YOSWidget dateStringWithTimeStamp:self.activityDetailModel.end_time Format:@"MM-dd EEEE HH:mm"]];
    YOSActivityDetailItemView *item0 = [[YOSActivityDetailItemView alloc] initWithImage:@"时间" title:time];
    item0.showBottomLine = YES;

    YOSActivityDetailItemView *item1 = [[YOSActivityDetailItemView alloc] initWithImage:@"地点" title:self.activityDetailModel.address];
    item1.showBottomLine = YES;
    
    YOSActivityDetailItemView *item2 = [[YOSActivityDetailItemView alloc] initWithImage:@"限制人数" title:[NSString stringWithFormat:@"限制人数: %@人", self.activityDetailModel.num]];
    item2.showBottomLine = YES;
    
    YOSActivityDetailItemView *item3 = [[YOSActivityDetailItemView alloc] initWithImage:@"报名截止时间" title:[YOSWidget dateStringWithTimeStamp:self.activityDetailModel.close_time Format:@"MM-dd EEEE HH:mm"]];
    item3.showBottomLine = YES;
    
    YOSActivityDetailItemView *item4 = [[YOSActivityDetailItemView alloc] initWithImage:@"类型" title:self.activityDetailModel.typeName];
    item4.showBottomLine = YES;
    
    NSString *money = nil;
    if ([self.activityDetailModel.price integerValue]) {
        money = [NSString stringWithFormat:@"费用: %@元", self.activityDetailModel.price];
    } else {
        money = @"费用: 免费";
    }
    
    YOSActivityDetailItemView *item5 = [[YOSActivityDetailItemView alloc] initWithImage:@"费用" title:money];

    [_lists addObjectsFromArray:@[item0, item1, item2, item3, item4, item5]];
    
    [_lists enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [_listView addSubview:obj];
    }];
    
    _introduceLabel = [_titleLabel yos_copySelf];
    _introduceLabel.text = @"活动介绍";
    [_contentView addSubview:_introduceLabel];
    
    
    _introduceDetailView = [UIView new];
    _introduceDetailView.layer.borderWidth = 0.5;
    _introduceDetailView.backgroundColor = [UIColor whiteColor];
    _introduceDetailView.layer.borderColor = YOSColorLineGray.CGColor;
    [_contentView addSubview:_introduceDetailView];
    
    _introduceDetailLabel = [YLLabel new];
    _introduceDetailLabel.textColor = YOSColorFontBlack;
    _introduceDetailLabel.font = YOSFontNormal;
    [_introduceDetailLabel setText:self.activityDetailModel.detail];
    
    [_introduceDetailView addSubview:_introduceDetailLabel];
    [_contentView addSubview:_introduceDetailView];
    
    _needLabel = [_titleLabel yos_copySelf];
    _needLabel.text = @"报名所需资料";
    
    [_contentView addSubview:_needLabel];
    
    _needContainerView = [UIView new];
    _needContainerView.backgroundColor = [UIColor whiteColor];
    _needContainerView.layer.borderColor = YOSColorLineGray.CGColor;
    _needContainerView.layer.borderWidth = 0.5;
    [_contentView addSubview:_needContainerView];
    
    // 开启审核
    NSMutableArray *audit = [NSMutableArray new];
    if ([self.activityDetailModel.is_audit boolValue]) {
        NSArray *temp = [self.activityDetailModel.audit componentsSeparatedByString:@","];
        
        [temp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            
            // 1姓名 2手机号码 3公司 4职位 5工作年限 6学历
            switch ([obj integerValue]) {
                case YOSAuditTypeName:
                    [audit addObject:@"姓名"];
                    break;
                    
                case YOSAuditTypeMobile:
                    [audit addObject:@"手机号码"];
                    break;
                    
                case YOSAuditTypeCompany:
                    [audit addObject:@"公司"];
                    break;
                    
                case YOSAuditTypeJobTitle:
                    [audit addObject:@"职位"];
                    break;
                    
                case YOSAuditTypeWorkYears:
                    [audit addObject:@"工作年限"];
                    break;
                    
                case YOSAuditTypeUniversity:
                    [audit addObject:@"学历"];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    } else {
        [audit addObject:@"姓名"];
        [audit addObject:@"手机号码"];
    }
    
    self.signConditions = audit;
    
    _needDetailView = [[YOSNeedView alloc] initWithTitles:audit];
    
    [_needContainerView addSubview:_needDetailView];
    
    _noticeLabel = [_titleLabel yos_copySelf];
    _noticeLabel.text = @"他们都关注了";
    
    [_contentView addSubview:_noticeLabel];
    
    _originatorView = [UIButton new];
    [_originatorView addTarget:self action:@selector(tappedOriginatorButton) forControlEvents:UIControlEventTouchUpInside];
    _originatorView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_originatorView];
    
    _originatorLabel = [UILabel new];
    _originatorLabel.textColor = YOSColorFontBlack;
    _originatorLabel.font = YOSFontNormal;
    _originatorLabel.text = @"发起人";
    [_originatorView addSubview:_originatorLabel];
    
    _originatorNameLabel = [_originatorLabel yos_copySelf];
    _originatorNameLabel.textColor = YOSColorFontGray;
    _originatorNameLabel.text = self.activityDetailModel.user.username;
    [_originatorView addSubview:_originatorNameLabel];
    
    _rightArrowImageView = [UIImageView new];
    _rightArrowImageView.image = [UIImage imageNamed:@"小箭头"];
    [_originatorView addSubview:_rightArrowImageView];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_contentView addSubview:_tableView];
    
    _moreUserButton = [UIButton new];
    [_moreUserButton setTitle:@"更多关注的人" forState:UIControlStateNormal];
    _moreUserButton.titleLabel.font = YOSFontBig;
    [_moreUserButton setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    [_moreUserButton addTarget:self action:@selector(tappedMoreUserButton) forControlEvents:UIControlEventTouchUpInside];
    _moreUserButton.backgroundColor = [UIColor whiteColor];
    
    [_contentView addSubview:_moreUserButton];
    
    _signButton = [UIButton new];
    [_signButton setTitle:@"报名参与" forState:UIControlStateNormal];
    [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signButton.titleLabel.font = YOSFontBig;
    [_signButton addTarget:self action:@selector(tappedSignButton) forControlEvents:UIControlEventTouchUpInside];
    [_signButton setBackgroundImage:[UIImage yos_imageWithColor:YOSRGB(249, 125, 77) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    
    [_contentView addSubview:_signButton];
    
    [self sendNetworkRequestForIsSignUp];
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
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_signButton);
    }];
    
    [_collectionContainterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, YOSAutolayout(112)));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, YOSAutolayout(112)));
        make.top.and.left.mas_equalTo(0);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(_collectionContainterView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_collectionContainterView.mas_bottom);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 44));
    }];
    
    __block CGFloat listHeight = 0.0f;
    [_lists enumerateObjectsUsingBlock:^(YOSActivityDetailItemView *obj, NSUInteger idx, BOOL *stop) {
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(listHeight);
            make.left.mas_equalTo(1);
            make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, obj.itemHeight));
        }];
        
        listHeight += obj.itemHeight;
    }];
    
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.left.mas_equalTo(-1);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth + 2, listHeight));
    }];
    
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_listView.mas_bottom);
    }];
    
    [_introduceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_listView);
        make.top.mas_equalTo(_introduceLabel.mas_bottom);
        make.left.mas_equalTo(_listView);
        make.bottom.mas_equalTo(_introduceDetailLabel.mas_bottom).offset(10);
    }];
    
//    _introduceDetailLabel.preferredMaxLayoutWidth = YOSScreenWidth - 20;
    [_introduceDetailLabel sizeToFit];
    [_introduceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.leading.mas_equalTo(4);
        make.size.mas_equalTo(_introduceDetailLabel.size);
    }];
    
    [_needLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_introduceDetailView.mas_bottom);
        make.left.mas_equalTo(10);
    }];
    
    [_needContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_needDetailView.heightOfNeedView + 30);
        make.width.mas_equalTo(YOSScreenWidth + 2);
        make.left.mas_equalTo(-1);
        make.top.mas_equalTo(_needLabel.mas_bottom);
    }];
    
    [_needDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_needDetailView.heightOfNeedView);
        make.width.mas_equalTo(YOSScreenWidth);
        make.left.mas_equalTo(1);
        make.top.mas_equalTo(15);
    }];
    
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_needContainerView.mas_bottom);
        make.size.mas_equalTo(_titleLabel);
        make.left.mas_equalTo(10);
    }];
    
    [_originatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 40));
        make.left.mas_equalTo(0);
    }];
    
    [_originatorLabel sizeToFit];
    [_originatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(_originatorView);
    }];
    
    [_rightArrowImageView sizeToFit];
    [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_originatorView);
    }];
    
    [_originatorNameLabel sizeToFit];
    [_originatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightArrowImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(_originatorView);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_originatorView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 60 * self.friends.count));
        make.left.mas_equalTo(0);
    }];
    
    CGFloat moreHeight = (self.friends.count ? 60 : 0);
    if (moreHeight == 0) {
        _moreUserButton.hidden = YES;
    }
    [_moreUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, moreHeight));
        make.left.mas_equalTo(0);
    }];
    
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 38));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_moreUserButton.mas_bottom);
    }];
}

#pragma mark - collection methods

- (void)addTimer
{
    [self removeTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)removeTimer
{
    // 停止定时器
    [_timer invalidate];
    _timer = nil;
}

- (NSIndexPath *)resetIndexPath
{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:numbersOfSections / 2];
    [_collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    return currentIndexPathReset;
}

/**
 *  下一页
 */
- (void)nextPage
{
    // 1.马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    
    // 2.计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.images.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 3.通过动画滚动到下一个位置
    [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return numbersOfSections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YOSCollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YOSCollectionImageCell" forIndexPath:indexPath];
    
    NSString *imageUrl = self.images[indexPath.item];
    
    cell.imageUrl = imageUrl;
    
    return cell;
}

#pragma - mark UIScrollViewDelegate
/**
 *  当用户即将开始拖拽的时候就调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (![scrollView isKindOfClass:[UICollectionView class]]) { return; }
    
    [self removeTimer];
}

/**
 *  当用户停止拖拽的时候就调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isKindOfClass:[UICollectionView class]]) { return; }
    
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UICollectionView class]]) { return; }
    
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.images.count;
    _pageControl.currentPage = page;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YOSFriendCell *cell = [YOSFriendCell cellWithTableView:tableView];
    
    cell.friendModel = self.friends[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.showTopLine = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // do nothing
    } else {
        YOSUpdateUserInfoViewController *updateVC = [YOSUpdateUserInfoViewController new];
        
        [self.navigationController pushViewController:updateVC animated:YES];
    }
}

#pragma mark - event response 

- (void)tappedOriginatorButton {
    NSLog(@"%s", __func__);
}

- (void)tappedMoreUserButton {
    NSLog(@"%s", __func__);
    
    YOSAttentionUserViewController *attentionVC = [[YOSAttentionUserViewController alloc] initWithAid:self.activityId];
    
    [self.navigationController pushViewController:attentionVC animated:YES];
}

- (void)tappedSignButton {
    NSLog(@"%s", __func__);
    
    // login
    if (![GVUserDefaults standardUserDefaults].currentLoginID.length) {
        YOSLoginViewController *loginVC = [YOSLoginViewController new];
        YOSBaseNavigationViewController *navVC = [[YOSBaseNavigationViewController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navVC animated:YES completion:nil];
        
        return;
    }
    
    [self sendNetworkRequestForSignUp];
}

#pragma mark - network

- (void)sendNetworkRequest {
    YOSActiveGetActiveRequest *request = [[YOSActiveGetActiveRequest alloc] initWithId:self.activityId];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        
        if ([request yos_checkResponse]) {
            self.activityDetailModel = [[YOSActivityDetailModel alloc] initWithDictionary:request.yos_data error:nil];
            
            [self.images addObject:self.activityDetailModel.thumb];
            
            if (self.activityDetailModel.picList) {
                NSArray *array = [self.activityDetailModel.picList componentsSeparatedByString:@","];
                
                if (array.count) {
                    [self.images addObjectsFromArray:array];
                }
            }
            
            self.friends = [YOSFriendModel arrayOfModelsFromDictionaries:request.yos_data[@"collect"]];
            
            [self setupSubviews];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        
        [request yos_checkResponse];
    }];
}

- (void)sendNetworkRequestForIsSignUp {
    
    if (![GVUserDefaults standardUserDefaults].currentLoginID.length) {
        return;
    }
    
    YOSActiveIsSignUpRequest *request = [[YOSActiveIsSignUpRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID andAid:self.activityId];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [request yos_checkResponse:NO];
        
        // 已报名
        if ([request.yos_baseResponseModel.code integerValue] == 200) {
            [self invalidSignButton];
        }
        
        // 已满员
        if ([request.yos_baseResponseModel.code integerValue] == 201) {
            [self fullSignButton];
        }
        
        // 未报名
        if ([request.yos_baseResponseModel.code integerValue] == 400) {
            [self validSignButton];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse:NO];
    }];
}

- (void)sendNetworkRequestForSignUp {
    
    YOSActiveSignUpRequest *request = [[YOSActiveSignUpRequest alloc] initWithUid:[GVUserDefaults standardUserDefaults].currentLoginID andAid:self.activityId];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [request yos_checkResponse:NO];
        
        // 报名成功
        if ([request.yos_baseResponseModel.code integerValue] == 200) {
            [self invalidSignButton];
        }
        
        // 已满员
        if ([request.yos_baseResponseModel.code integerValue] == 201) {
            [self fullSignButton];
            [SVProgressHUD showInfoWithStatus:@"当前活动已满员啦~" maskType:SVProgressHUDMaskTypeClear];
        }
        
        // 条件不足
        if ([request.yos_baseResponseModel.code integerValue] == 400) {
            
            NSString *string = [self.signConditions componentsJoinedByString:@","];
            
            NSString *warnString = [NSString stringWithFormat:@"报名需要补全这些资料哦:\r\n%@", string];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:warnString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去补全", nil];
            
            [alert show];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        [request yos_checkResponse];
    }];
}

#pragma mark - private methods

- (void)invalidSignButton {
    [_signButton setTitle:@"已报名" forState:UIControlStateNormal];
    _signButton.enabled = NO;
}

- (void)validSignButton {
    [_signButton setTitle:@"报名参与" forState:UIControlStateNormal];
    _signButton.enabled = YES;
}

- (void)fullSignButton {
    [_signButton setTitle:@"已满员" forState:UIControlStateNormal];
    _signButton.enabled = NO;
}

#pragma mark - getter & setter

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    
    return _images;
}

@end
