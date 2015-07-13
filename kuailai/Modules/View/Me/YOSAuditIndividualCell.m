//
//  YOSAuditIndividualCell.m
//  kuailai
//
//  Created by yangyang on 15/7/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAuditIndividualCell.h"

#import "EDColor.h"
#import "Masonry.h"

@interface YOSAuditIndividualCell ()

@end

@implementation YOSAuditIndividualCell {
    UIView *_bottomLineView;
    UILabel *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_bottomLineView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = YOSColorFontBlack;
    _titleLabel.font = YOSFontNormal;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
    }];
    
}

- (void)setString:(NSString *)string {
    _string = string;
    
    _titleLabel.text = string;
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(YOSScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _titleLabel.font} context:nil].size;
    
    size = CGSizeMake(ceil(YOSScreenWidth - 20), ceil(size.height));
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(size);
    }];
}

@end
