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
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"产品分享"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftItem:)];
    
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
