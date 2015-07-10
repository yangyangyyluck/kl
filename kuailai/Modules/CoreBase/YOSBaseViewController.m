//
//  YOSBaseViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/3.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseViewController.h"

/**
 *  dissmiss 会销毁SVProgressHUD
 */
#import "SVProgressHUD+YOSAdditions.h"

@interface YOSBaseViewController ()

@end

@implementation YOSBaseViewController

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)setTitle:(NSString *)title {
    [self setupNavTitle:title];
}

+ (instancetype)viewControllerFromStoryboardWithSBName:(NSString *)name {
    
    typeof([self new]) vcClass = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    
    vcClass = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    return vcClass;
}

- (void)setupBackArrow {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickLeftItem:) forControlEvents:UIControlEventTouchUpInside];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    }else{
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    item.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = item;
}

/**
 *	@brief	自定义titlte居中处理
 *
 *	@param 	text 	title
 */
- (void)setupNavTitle:(NSString *)title
{
    UILabel *label = [UILabel new];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0f];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:dict];
    
    label.attributedText = attributedString;
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
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
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)clickLeftItem:(UIButton *)item {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickRightItem:(UIButton *)item {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupKuaiLai {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"快来水印"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 20);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    btn.adjustsImageWhenHighlighted = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = item;
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
