//
//  YOSBaseNavigationViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/3.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSBaseNavigationViewController.h"
#import "SVProgressHUD+YOSAdditions.h"

@interface YOSBaseNavigationViewController ()

@end

@implementation YOSBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = YOSColorMainRed;
    self.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.tabBarController.tabBar.translucent = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [SVProgressHUD dismiss];
    
    NSLog(@"\r\n\r\n\r\n now push vc is : %@ animated : %zi\r\n\r\n\r\n", NSStringFromClass([viewController class]), animated);
    
    [super pushViewController:viewController animated:animated];
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
