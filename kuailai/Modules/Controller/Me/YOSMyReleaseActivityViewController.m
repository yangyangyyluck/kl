//
//  YOSMyReleaseActivityViewController.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyReleaseActivityViewController.h"
#import "YOSMyActivityView.h"

@implementation YOSMyReleaseActivityViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackArrow];
    
    [self setupSegmented];
    
    YOSMyActivityView *v = [YOSMyActivityView new];
    v.frame = CGRectMake(0, 100, YOSScreenWidth, 110);
    
    [self.view addSubview:v];
    v.backgroundColor = YOSColorRandom;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - private method list

- (void)setupSegmented {
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"已审核", @"未审核"]];
    segmented.frame = CGRectMake(11, 10, 180, 30);
    segmented.selectedSegmentIndex = 0;
    segmented.tintColor = [UIColor whiteColor];
    [segmented addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmented;

}

- (void)segmentedValueChanged:(UISegmentedControl *)segmented {
    // 已审核
    if (segmented.selectedSegmentIndex == 0) {
        YOSLog(@"已审核");
    }
    
    // 未审核
    if (segmented.selectedSegmentIndex == 1) {
        YOSLog(@"未审核");
    }
}

@end
