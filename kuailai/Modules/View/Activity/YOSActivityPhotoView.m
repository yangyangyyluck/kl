//
//  YOSActivityPhotoView.m
//  kuailai
//
//  Created by yangyang on 15/5/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSActivityPhotoView.h"
#import "EDColor.h"

@interface YOSActivityPhotoView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation YOSActivityPhotoView

- (IBAction)clickBtn:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

- (void)awakeFromNib {
    NSString *text = @"上传活动图片(推荐上传横幅图片，最多4张)";
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    
    UIColor *blackColor = [UIColor colorWithHexString:@"#858585"];
    
    [attributeText setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName : blackColor} range:NSMakeRange(0, 6)];
    
    [attributeText setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName : YOSRGB(210, 210, 210)} range:NSMakeRange(6, text.length - 6)];
    
    self.titleLabel.attributedText = attributeText;
}

- (UIButton *)createButton {
    UIButton *btn = [UIButton new];
    [btn setBackgroundImage:[UIImage imageNamed:@"创建图片"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
