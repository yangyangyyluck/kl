//
//  YOSPersentViewController.m
//  kuailai
//
//  Created by yangyang on 15/5/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSPresentViewController.h"

#import "SVProgressHUD+YOSAdditions.h"

@interface YOSPresentViewController ()

@property (nonatomic, strong) UINavigationBar *yos_navigationBar;

@property (nonatomic, strong) UINavigationItem *yos_navigationItem;

@end

@implementation YOSPresentViewController {

}

- (UINavigationBar *)yos_navigationBar {
    if (!_yos_navigationBar) {
        _yos_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, YOSScreenWidth, 64)];
    }
    
    return _yos_navigationBar;
}

- (UINavigationItem *)yos_navigationItem {
    if (!_yos_navigationItem) {
        _yos_navigationItem = [UINavigationItem new];
        [self.yos_navigationBar pushNavigationItem:_yos_navigationItem animated:NO];
    }
    
    return _yos_navigationItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    self.yos_navigationBar.barTintColor = YOSRGB(252, 106, 67);
    [self.view addSubview:self.yos_navigationBar];
}

- (void)setupNavTitle:(NSString *)title {
    UILabel *label = [UILabel new];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0f];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:dict];
    
    label.attributedText = attributedString;
    [label sizeToFit];
    
    self.yos_navigationItem.titleView = label;
}

- (void)setupLeftButtonWithTitle:(NSString *)title {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(clickLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger offset = 0;
    if (title.length == 2) {
        offset = -80;
    }
    
    if (title.length == 4) {
        offset = -50;
    }
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    item.tintColor = [UIColor whiteColor];
    
    self.yos_navigationItem.leftBarButtonItem = item;
}

- (void)clickLeftItem:(UIButton *)item {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupRightButtonWithTitle:(NSString *)title {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger offset = 0;
    if (title.length == 2) {
        offset = -80;
    }
    
    if (title.length == 4) {
        offset = -50;
    }
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, offset)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    item.tintColor = [UIColor whiteColor];
    
    self.yos_navigationItem.rightBarButtonItem = item;
}

- (void)clickRightItem:(UIButton *)item {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
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
