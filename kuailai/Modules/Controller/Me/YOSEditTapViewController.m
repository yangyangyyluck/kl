//
//  YOSEditTapViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSEditTapViewController.h"
#import "YOSTapEditView.h"

#import "Masonry.h"

@implementation YOSEditTapViewController {
    YOSTapEditView *_tapEditView;
}

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavTitle:@"我的标签"];
    [self setupBackArrow];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _tapEditView = [[YOSTapEditView alloc] initWithTapArray:@[@"帅锅", @"超级大帅锅", @"帅到京东了党", @"super Mario", @"King of the worlD", @"hello skipper", @"be", @"ok super."]];
    
    [self.view addSubview:_tapEditView];
    
    _tapEditView.backgroundColor = YOSColorRandom;
    [_tapEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
}

@end
