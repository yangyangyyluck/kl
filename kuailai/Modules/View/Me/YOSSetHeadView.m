//
//  YOSSetHeadView.m
//  kuailai
//
//  Created by yangyang on 15/6/24.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSSetHeadView.h"

#import "YOSUserInfoModel.h"

#import "EDColor.h"
#import "YOSWidget.h"
#import "UIButton+WebCache.h"

@interface YOSSetHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *headImageView;

@end

@implementation YOSSetHeadView

- (void)awakeFromNib {
    self.titleLabel.textColor = YOSColorFontGray;
    
    YOSUserInfoModel *model = [YOSWidget getCurrentUserInfoModel];
    
    if (!model.avatar) {
        [self.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        [self.headImageView setBackgroundImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    }
    
    [self.headImageView addTarget:self action:@selector(tappedHeadImageButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - event response

- (void)tappedHeadImageButton {
    NSLog(@"%s", __func__);
}

@end
