//
//  YOSMeViewController.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMeViewController.h"
#import "YOSCreateActivityViewController.h"
#import "XXNibBridge.h"
@interface YOSMeViewController ()

@end

@implementation YOSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.hidesBottomBarWhenPushed = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    
    YOSCreateActivityViewController *vc = [YOSCreateActivityViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
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
