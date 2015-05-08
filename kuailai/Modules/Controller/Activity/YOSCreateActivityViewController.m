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
    
    // 容器view
    UIView *_contentView;
    
    YOSInputView *_inputView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    _contentView = [UIView new];
    
    _inputView = [[YOSInputView alloc] initWithTitle:@"活动标题:" selectedStatus:NO maxCharacters:140 maxLines:0];
    _inputView.backgroundColor = [UIColor lightGrayColor];
    
    _contentView.backgroundColor = YOSRGB(238, 238, 238);

    [self.view addSubview:_contentView];
    [_contentView addSubview:_inputView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topLayoutGuide).offset(170);
    }];
}

#pragma mark - touchEvent
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    YOSLog(@"%zi", _inputView.text.length);
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
