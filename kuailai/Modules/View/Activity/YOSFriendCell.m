//
//  YOSFriendCell.m
//  kuailai
//
//  Created by yangyang on 15/6/18.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSFriendCell.h"

#import "YOSFriendModel.h"

#import "EDColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


@implementation YOSFriendCell {
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_jobTitleLabel;
    UILabel *_companyLabel;
    
    UIView *_topLineView;
    UIView *_bottomLineView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *reuseIdentifier = @"YOSFriendCell";
    
    YOSFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setupSubviews];
    
    return self;
}

- (void)setupSubviews {
    _headImageView = [UIImageView new];
    _headImageView.layer.cornerRadius = 20;
    _headImageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_headImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = YOSFontBig;
    _nameLabel.textColor = YOSColorFontBlack;
    
    [self.contentView addSubview:_nameLabel];
    
    _jobTitleLabel = [UILabel new];
    _jobTitleLabel.font = YOSFontSmall;
    _jobTitleLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_jobTitleLabel];
    
    _companyLabel = [UILabel new];
    _companyLabel.font = [UIFont systemFontOfSize:14.0f];
    _companyLabel.textColor = YOSColorFontGray;
    [self.contentView addSubview:_companyLabel];
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = YOSColorLineGray;
    
    [self.contentView addSubview:_topLineView];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = YOSColorLineGray;
    
    [self.contentView addSubview:_bottomLineView];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 0.5));
        make.left.and.top.mas_equalTo(0);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_topLineView);
        make.left.and.bottom.mas_equalTo(0);
    }];
    
    _topLineView.hidden = YES;
    _bottomLineView.hidden = NO;
}

#pragma mark -getter & setter

- (void)setFriendModel:(YOSFriendModel *)friendModel {
    _friendModel = friendModel;
    
    if (friendModel.avatar) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:friendModel.avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"默认头像"];
    }
    
    _nameLabel.text = friendModel.nickname;
    _jobTitleLabel.text = (friendModel.position.length ? friendModel.position : @"暂无职位信息");
    _companyLabel.text = (friendModel.company.length ? friendModel.company : @"暂无公司信息");
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.left.mas_equalTo(_headImageView.mas_right).offset(8);
        make.top.mas_equalTo(_headImageView).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 19));
    }];
    
    [_jobTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.centerY.mas_equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(120, 16));
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        
        make.bottom.mas_equalTo(_headImageView).offset(2);
        make.left.mas_equalTo(_nameLabel);
        make.size.mas_equalTo(CGSizeMake(150, 18));
    }];
    
}

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    
    _topLineView.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    
    _bottomLineView.hidden = !showBottomLine;
}

@end
