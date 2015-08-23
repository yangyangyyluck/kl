//
//  YOSAboutUsViewController.m
//  kuailai
//
//  Created by yangyang on 15/8/23.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAboutUsViewController.h"
#import "YLLabel.h"

#import "EDColor.h"
#import "Masonry.h"

@implementation YOSAboutUsViewController {
    YLLabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupBackArrow];
    
    [self setupNavTitle:@"关于快来吧"];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *string = @"    快来吧是北京快莱科技有限公司（简称\"快莱\"）2015年8月推出的一款基于线下互联网主题活动的商务社交产品。来吧聚集互联网各岗位人脉、各类资源，数据挖掘精准匹配推荐、帮助需求者找到合适的人脉、合适的资源、互联网从业者在这里享有高品质、高效率以及低成本的商务市场合作。在这里你能找到志趣相同的伙伴，扩展自己的视野、打破惯性思维找到工作瓶颈的突破口为公司带来更高的价值。快莱理念：社交回归线下，促进商务商务合作！";
    
    _label = [YLLabel new];
    _label.textColor = YOSColorFontBlack;
    _label.font = YOSFontNormal;
    [_label setText:string];
    
    [self.view addSubview:_label];

    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 0, 10, 0)).priorityLow();
    }];
}

@end
