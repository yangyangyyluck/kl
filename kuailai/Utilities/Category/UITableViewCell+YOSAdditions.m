//
//  UITableViewCell+YOSAdditions.m
//  kuailai
//
//  Created by yangyang on 15/7/2.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "UITableViewCell+YOSAdditions.h"

@implementation UITableViewCell (YOSAdditions)

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];

    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

@end
