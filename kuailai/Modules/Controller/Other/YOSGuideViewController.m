//
//  YOSGuideViewController.m
//  kuailai
//
//  Created by yangyang on 15/9/1.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSGuideViewController.h"

#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"
#import "YOSWidget.h"

@interface YOSGuideViewController() <UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) UIImageView *transitionImageView;

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation YOSGuideViewController {
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    NSMutableArray *_pictureViews;
    NSMutableArray *_wordViews;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backgroundView = [UIImageView new];
    UIImage *image = [self launchImage];
    _backgroundView.image = image;
    _backgroundView.userInteractionEnabled = YES;
    
    [self.view addSubview:_backgroundView];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, YOSScreenHeight));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupGuide];
    
    [self animationWordWithIndex:0];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    _pictureViews = [NSMutableArray array];
    _wordViews = [NSMutableArray array];
    
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.and.left.mas_equalTo(0);
        make.height.mas_equalTo(YOSScreenHeight);
        make.width.mas_equalTo(4 * YOSScreenWidth);
    }];
    
    CGFloat score = 2.0;
    if (YOSIsIphone6P) {
        score = 3.0;
    }
    
    for (NSUInteger i = 1; i <= 4; ++i) {
        UIImageView *pictureView = [UIImageView new];
        pictureView.userInteractionEnabled = YES;
        pictureView.image = [self pictureWithNumber:i];
        [_pictureViews addObject:pictureView];
        
        [_contentView addSubview:pictureView];
        
        [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo((i - 1) * YOSScreenWidth);
            make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, YOSScreenHeight));
        }];
        
        if (i <= 3) {
            UIImageView *wordView = [UIImageView new];
            wordView.userInteractionEnabled = YES;
            wordView.image = [self wordWithNumber:i];
            wordView.alpha = 0.0;
            [_wordViews addObject:wordView];
            
            [pictureView addSubview:wordView];
            
            [wordView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-30);
                make.right.mas_equalTo(-30);
                make.size.mas_equalTo(CGSizeMake(wordView.image.size.width / score, wordView.image.size.height / score));
            }];
        } else {
            UIButton *btn = [UIButton new];
            [pictureView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 49));
                make.bottom.and.right.mas_equalTo(0);
            }];
            
            [btn addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
}

#pragma mark - event response

- (void)tappedButton {
    NSLog(@"%s", __func__);
    
    [GVUserDefaults standardUserDefaults].lastVersion = [YOSWidget currentAppVersion];
    [GVUserDefaults standardUserDefaults].alertUpdateMessageCount = 0;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showTabBarVC];

}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger page = (NSUInteger)floor(scrollView.contentOffset.x / YOSScreenWidth);
    
    self.currentPage = page;
    
    [self animationWordWithIndex:self.currentPage];
    
    NSLog(@"currentPage --- %zi", page);
}

#pragma mark - private methods

- (void)showTransitionAnimation {
    _transitionImageView = [UIImageView new];
    UIImage *image = [self launchImage];
    _transitionImageView.image = image;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:_transitionImageView];
    
    [_transitionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, YOSScreenHeight));
    }];
}

- (void)hideTransitionAnimation {
    YOSWSelf(weakSelf);
    [UIView animateWithDuration:1.0f animations:^{
        weakSelf.transitionImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.transitionImageView removeFromSuperview];
    }];
}

- (void)setupGuide {
    
    NSString *currentVersion = [YOSWidget currentAppVersion];
    NSString *lastVersion = [GVUserDefaults standardUserDefaults].lastVersion;
    
    // show guide
    if ([YOSWidget compareAppVersion1:currentVersion andAppVersion2:lastVersion] == NSOrderedDescending) {
        [self setupSubviews];
    } else {
        [self showTransitionAnimation];
        [self showTabBarVC];
    }
    
}

- (void)showTabBarVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *tabBarVC = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([UITabBarController class])];
    
    YOSWSelf(weakSelf);
    [self presentViewController:tabBarVC animated:NO completion:^{
        [weakSelf hideTransitionAnimation];
    }];

}

- (void)animationWordWithIndex:(NSUInteger)index {

    [_wordViews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        
        if (idx != index) {
            obj.alpha = 0.0;
        } else {
            [UIView animateWithDuration:1.25f animations:^{
                obj.alpha = 1.0;
            }];
        }
        
    }];
}

- (UIImage *)pictureWithNumber:(NSUInteger)num {
    
    NSUInteger screenHeight = 960;
    if (YOSIsIphone4) {
        screenHeight = 960;
    }
    
    if (YOSIsIphone5) {
        screenHeight = 1136;
    }
    
    if (YOSIsIphone6) {
        screenHeight = 1334;
    }
    
    if (YOSIsIphone6P) {
        screenHeight = 2208;
    }
    
    NSString *name = [NSString stringWithFormat:@"0%zi图-%zi.jpg", num, screenHeight];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resourses" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:name ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

- (UIImage *)wordWithNumber:(NSUInteger)num {
    
    NSUInteger screenHeight = 960;
    if (YOSIsIphone4) {
        screenHeight = 960;
    }
    
    if (YOSIsIphone5) {
        screenHeight = 1136;
    }
    
    if (YOSIsIphone6) {
        screenHeight = 1334;
    }
    
    if (YOSIsIphone6P) {
        screenHeight = 2208;
    }
    
    NSString *name = [NSString stringWithFormat:@"0%zi字-%zi.png", num, screenHeight];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resourses" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:name ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

- (UIImage *)launchImage {
    NSUInteger screenHeight = 960;
    if (YOSIsIphone4) {
        screenHeight = 960;
    }
    
    if (YOSIsIphone5) {
        screenHeight = 1136;
    }
    
    if (YOSIsIphone6) {
        screenHeight = 1334;
    }
    
    if (YOSIsIphone6P) {
        screenHeight = 2208;
    }
    
    NSString *name = [NSString stringWithFormat:@"启动页-%zi.png", screenHeight];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resourses" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:name ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

@end
