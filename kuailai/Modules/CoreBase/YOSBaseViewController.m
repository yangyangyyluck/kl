//
//  YOSBaseViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/3.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseViewController.h"

@interface YOSBaseViewController ()

@end

@implementation YOSBaseViewController

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

- (void)clickLeftItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
