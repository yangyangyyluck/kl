//
//  YOSAuditCollectionViewCell.m
//  kuailai
//
//  Created by yangyang on 15/7/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAuditCollectionViewCell.h"
#import "YOSActivityAuditIndividualView.h"

#import "Masonry.h"

@implementation YOSAuditCollectionViewCell {
    YOSActivityAuditIndividualView *_auditIndividualView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _auditIndividualView = [YOSActivityAuditIndividualView new];
    
    [self.contentView addSubview:_auditIndividualView];
    
    [_auditIndividualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
}

- (void)setUserInfoModel:(YOSUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    _auditIndividualView.userInfoModel = userInfoModel;
}

@end
