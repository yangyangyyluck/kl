//
//  YOSMyAttendCell.m
//  kuailai
//
//  Created by yangyang on 15/7/13.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSMyAttendCell.h"
#import "YOSMyActivityView.h"

#import "Masonry.h"

@implementation YOSMyAttendCell {
    YOSMyActivityView *_myActivityView;
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
    _myActivityView = [YOSMyActivityView new];
    _myActivityView.showTopLine = NO;
    
    [self.contentView addSubview:_myActivityView];
    
    [_myActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.width.mas_equalTo(YOSScreenWidth);
    }];
}

- (void)setActivityListModel:(YOSActivityListModel *)activityListModel {
    _activityListModel = activityListModel;
    
    _myActivityView.activityListModel = activityListModel;
}

@end
