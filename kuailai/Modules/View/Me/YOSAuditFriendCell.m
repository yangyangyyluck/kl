//
//  YOSAuditFriendCell.m
//  kuailai
//
//  Created by yangyang on 15/7/1.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSAuditFriendCell.h"

@implementation YOSAuditFriendCell {
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YOSAuditFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YOSAuditFriendCell"];
    
    if (!cell) {
        cell = [[YOSAuditFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YOSAuditFriendCell"];
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
    
}

@end
