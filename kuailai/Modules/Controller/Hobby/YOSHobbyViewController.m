//
//  YOSHobbyViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSHobbyViewController.h"
#import "YOSHobbyButton.h"

#import "Masonry.h"
#import "EDColor.h"

@interface YOSHobbyViewController() <UISearchBarDelegate>

@end

@implementation YOSHobbyViewController {
    UIView *_contentView;
    UIView *_bottomContentView;
    UIImageView *_kuaiLaiImageView;
    
    UISearchBar *_searchBar;
    
    YOSHobbyButton *_btn0;
    YOSHobbyButton *_btn1;
    YOSHobbyButton *_btn2;
    YOSHobbyButton *_btn3;
    YOSHobbyButton *_btn4;
    YOSHobbyButton *_btn5;
    
    NSMutableArray *_btns;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchBar];
    
    [self setupSubviews];
}

- (void)setupSearchBar {
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"搜索你想要的一切: )";
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.delegate = self;
    _searchBar.barTintColor = YOSColorLineGray;
    [self.view addSubview:_searchBar];

    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 44));
    }];
}

- (void)setupSubviews {
    
    _contentView = [UIView new];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.mas_equalTo(_searchBar.mas_bottom);
    }];
    
    _btns = [NSMutableArray array];
    
    _btn0 = [[YOSHobbyButton alloc] initWithImageName:@"商务市场" title:@"商务市场"];
    [_contentView addSubview:_btn0];
    
    _btn1 = [[YOSHobbyButton alloc] initWithImageName:@"黑马创业" title:@"黑马创业"];
    [_contentView addSubview:_btn1];
    
    _btn2 = [[YOSHobbyButton alloc] initWithImageName:@"产品分享" title:@"产品分享"];
    [_contentView addSubview:_btn2];
    
    _btn3 = [[YOSHobbyButton alloc] initWithImageName:@"技术交流" title:@"技术交流"];
    [_contentView addSubview:_btn3];
    
    _btn4 = [[YOSHobbyButton alloc] initWithImageName:@"沙龙小聚" title:@"沙龙小聚"];
    [_contentView addSubview:_btn4];
    
    _btn5 = [[YOSHobbyButton alloc] initWithImageName:@"户外休闲" title:@"户外休闲"];
    [_contentView addSubview:_btn5];
    
    [_btns addObjectsFromArray:@[_btn0, _btn1, _btn2, _btn3, _btn4, _btn5]];
    
    [_btns enumerateObjectsUsingBlock:^(YOSHobbyButton *obj, NSUInteger idx, BOOL *stop) {
        
        
        
        // left
        if (idx % 2 == 0) {
            NSUInteger num = idx / 2;
            
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(YOSScreenWidth / 2, 75));
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(num * 75);
            }];
            
            if (num == 0) {
                obj.showTopLine = YES;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = YES;
            } else {
                obj.showTopLine = NO;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = YES;
            }
            
        } else {    // right
            CGFloat f = idx / 2.0;
            NSUInteger num = ceil(f);
            
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(_btn0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo((num - 1) * 75);
            }];
            
            if (num == 0) {
                obj.showTopLine = YES;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = NO;
            } else {
                obj.showTopLine = NO;
                obj.showLeftLine = NO;
                obj.showBottomLine = YES;
                obj.showRightLine = NO;
            }
        }
        
    }];
    
    _bottomContentView = [UIView new];
    
    [_contentView addSubview:_bottomContentView];
    
    [_bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(_btn5.mas_bottom);
    }];
    
    _kuaiLaiImageView = [UIImageView new];
    _kuaiLaiImageView.image = [UIImage imageNamed:@"快来水印"];
    [_bottomContentView addSubview:_kuaiLaiImageView];
    
    [_kuaiLaiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_bottomContentView);
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
    
    NSString *name = searchBar.text;
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!name.length) {
        return;
    }
    
//    [self sendNetworkRequestWithType:YOSRefreshTypeHeader isSearch:YES];
}

@end
