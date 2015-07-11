//
//  YOSEditTapViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/9.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTagEditViewController.h"
#import "YOSTapEditView.h"

#import "Masonry.h"
#import "GVUserDefaults+YOSProperties.h"

@implementation YOSTagEditViewController {
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
    
    NSDictionary *data = [GVUserDefaults standardUserDefaults].currentTagDictionary;
    
    NSArray *array = nil;
    if (data) {
        array = data[@"data"];
    }
    
    _tapEditView = [YOSTapEditView new];
    _tapEditView.tapArray = array;
    
    [self.view addSubview:_tapEditView];
    
    _tapEditView.backgroundColor = YOSColorRandom;
    [_tapEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
}

@end
