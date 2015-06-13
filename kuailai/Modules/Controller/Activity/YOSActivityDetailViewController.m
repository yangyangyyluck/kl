//
//  YOSActivityDetailViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityDetailViewController.h"
#import "YOSActivityDetailItemView.h"
#import "YOSCollectionImageCell.h"

#import "YOSActiveGetActiveRequest.h"

#import "YOSActivityDetailModel.h"

#import "Masonry.h"
#import "EDColor.h"
#import "YOSWidget.h"
#import "UIView+YOSAdditions.h"

static const NSUInteger numbersOfSections = 100;

@interface YOSActivityDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, strong) YOSActivityDetailModel *activityDetailModel;

@property (nonatomic, strong) NSMutableArray *images;

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
    UILabel *_introduceDetailLabel;
    
    // 报名所需资料
    UILabel *_needLabel;
    
    // 资料按钮
    UIView *_needDetailView;
    
}

- (instancetype)initWithActivityId:(NSString *)activityId {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityId = activityId;
    
    [self sendNetworkRequest];
    
    return self;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"活动详情"];
    
    [self setupBackArrow];
    
    self.view.backgroundColor = YOSColorBackgroundGray;
}

- (void)setupSubviews {
    
    _scrollView = [UIScrollView new];
    _contentView = [UIView new];
    _contentView.backgroundColor = YOSColorBackgroundGray;
    _scrollView.backgroundColor = [UIColor whiteColor];
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
        make.height.mas_equalTo(YOSScreenHeight);
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

#pragma mark - network

- (void)sendNetworkRequest {
    YOSActiveGetActiveRequest *request = [[YOSActiveGetActiveRequest alloc] initWithId:self.activityId];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request yos_checkResponse]) {
            self.activityDetailModel = [[YOSActivityDetailModel alloc] initWithDictionary:request.yos_data error:nil];
            
            [self.images addObject:self.activityDetailModel.thumb];
            
            if (self.activityDetailModel.picList) {
                NSArray *array = [self.activityDetailModel.picList componentsSeparatedByString:@","];
                
                if (array.count) {
//                    [self.images addObjectsFromArray:array];
                    
                    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [self.images addObject:self.activityDetailModel.thumb];
                    }];
                }
            }
            
            [self setupSubviews];
        }
    } failure:^(YTKBaseRequest *request) {
        [request yos_checkResponse];
    }];
}

#pragma mark - getter & setter

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    
    return _images;
}

@end
