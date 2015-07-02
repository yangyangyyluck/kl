//
//  YOSMyReleaseCell.m
//  kuailai
//
//  Created by yangyang on 15/6/30.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyReleaseCell.h"
#import "YOSActivityAuditViewController.h"
#import "UIView+YOSAdditions.h"
#import "YOSMyActivityView.h"

#import "YOSActivityListModel.h"
#import "EDColor.h"
#import "Masonry.h"

@implementation YOSMyReleaseCell {
    YOSMyActivityView *_myActivityView;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIView *_middleLineView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YOSMyReleaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YOSMyReleaseCell"];
    
    if (!cell) {
        cell = [[YOSMyReleaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YOSMyReleaseCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
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
    _myActivityView = [YOSMyActivityView new];
    [self.contentView addSubview:_myActivityView];
    
    _leftButton = [UIButton new];
    _leftButton.titleLabel.font = YOSFontNormal;
    [_leftButton setTitle:@"验票" forState:UIControlStateNormal];
    [_leftButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(tappedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_leftButton];
    
    _rightButton = [UIButton new];
    _rightButton.titleLabel.font = YOSFontNormal;
    [_rightButton setTitle:@"审核报名" forState:UIControlStateNormal];
    [_rightButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(tappedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightButton];
    
    _middleLineView = [UIView new];
    _middleLineView.backgroundColor = YOSColorLineGray;
    [self.contentView addSubview:_middleLineView];
    
    [_myActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth, 110));
        make.left.and.top.mas_equalTo(0);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(YOSScreenWidth / 2 - 0.3, 44));
        make.left.and.bottom.mas_equalTo(0);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_leftButton);
        make.right.and.bottom.mas_equalTo(0);
    }];
    
    [_middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 44));
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)setActivityListModel:(YOSActivityListModel *)activityListModel {
    _activityListModel = activityListModel;
    
    // do something..
    _myActivityView.activityListModel = activityListModel;
    
    if ([activityListModel.status integerValue] == 0) {
        [_leftButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
        [_rightButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
    } else {
        [_leftButton setTitleColor:YOSColorFontGray forState:UIControlStateNormal];
        [_rightButton setTitleColor:YOSColorMainRed forState:UIControlStateNormal];
    }
    
    _leftButton.enabled = [activityListModel.status integerValue];
    _rightButton.enabled = [activityListModel.status integerValue];
}

#pragma mark - event response

- (void)tappedLeftButton {
    NSLog(@"%s", __func__);
}

- (void)tappedRightButton {
    NSLog(@"%s", __func__);
    YOSActivityAuditViewController *auditVC = [[YOSActivityAuditViewController alloc] initWithActivityListModel:self.activityListModel];
    
    [self.yos_viewController.navigationController pushViewController:auditVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
