//
//  YOSCreateActivityViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSCreateActivityViewController.h"
#import "YOSInputView.h"
#import "Masonry.h"

@interface YOSCreateActivityViewController ()

@end

@implementation YOSCreateActivityViewController {
    YOSInputView *_inputView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    _inputView = [[YOSInputView alloc] initWithTitle:@"活动标题:" selectedStatus:YES];
    _inputView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_inputView];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
//        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.topLayoutGuide).offset(170);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
