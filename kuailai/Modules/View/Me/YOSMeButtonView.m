//
//  YOSMeButtonView.m
//  kuailai
//
//  Created by yangyang on 15/6/22.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMeButtonView.h"
#import "YOSHeadButton.h"
#import "Masonry.h"

#import "UIView+YOSAdditions.h"
#import "EDColor.h"

@interface YOSMeButtonView ()

@property (weak, nonatomic) IBOutlet YOSHeadButton *button0;

@property (weak, nonatomic) IBOutlet YOSHeadButton *button1;

@property (weak, nonatomic) IBOutlet YOSHeadButton *button2;

@end

@implementation YOSMeButtonView

- (void)awakeFromNib {
    [self.button0 setImage:[UIImage imageNamed:@"发布活动"] forState:UIControlStateNormal];
    self.button0.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.button0.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.button0.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.button0 setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    [self.button0 setTitle:@"发布活动" forState:UIControlStateNormal];
    
    [self.button1 setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    self.button1.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.button1.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.button1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.button1 setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    [self.button1 setTitle:@"我的收藏" forState:UIControlStateNormal];
    
    [self.button2 setImage:[UIImage imageNamed:@"我的好友"] forState:UIControlStateNormal];
    self.button2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.button2.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.button2 setTitleColor:YOSColorFontBlack forState:UIControlStateNormal];
    [self.button2 setTitle:@"我的好友" forState:UIControlStateNormal];
    
    UIView *leftLineView = [UIView new];
    leftLineView.backgroundColor = YOSColorLineGray;
    [self addSubview:leftLineView];
    
    CGFloat margin = ((YOSScreenWidth / 2) - 30 - 55 - 25.5) / 2;
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 35));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.button1.mas_left).offset(-margin);
    }];
    
    UIView *rightLineView = [leftLineView yos_copySelf];
    [self addSubview:rightLineView];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(leftLineView);
        make.centerY.mas_equalTo(leftLineView);
        make.left.mas_equalTo(self.button1.mas_right).offset(margin);
    }];
    
    UIView *topLineView = [leftLineView yos_copySelf];
    [self addSubview:topLineView];
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
    }];
    
    UIView *bottomLineView = [leftLineView yos_copySelf];
    [self addSubview:bottomLineView];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.mas_equalTo(0);
        make.size.mas_equalTo(topLineView);
    }];
    
}

#pragma mark - event response

- (IBAction)tappedButton0:(id)sender {
    NSLog(@"%s", __func__);
    [self.button0 setImage:[UIImage imageNamed:@"发布活动"] forState:UIControlStateNormal];
}
- (IBAction)tappedButton1:(id)sender {
    NSLog(@"%s", __func__);
}
- (IBAction)tappedButton2:(id)sender {
    NSLog(@"%s", __func__);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
