//
//  YOSTestViewController.m
//  kuailai
//
//  Created by yangyang on 15/7/12.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTestViewController.h"

#import "UIImage+MDQRCode.h"

@implementation YOSTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [UIImageView new];
    iv.frame = CGRectMake(40, 40, 100, 100);
//    iv.backgroundColor = [UIColor grayColor];
    
    UIImage *image = [UIImage mdQRCodeForString:@"1-23-abcd" size:100];
    
    iv.image = image;
    
    [self.view addSubview:iv];
}

@end
