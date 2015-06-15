//
//  YOSDetailLabel.m
//  kuailai
//
//  Created by yangyang on 15/6/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSDetailLabel.h"

@implementation YOSDetailLabel

- (void)setAttributedText:(NSAttributedString *)attributedText {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 5.0f;
    
    NSMutableAttributedString *mAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mAttributedText setAttributes:@{NSParagraphStyleAttributeName : style} range:NSMakeRange(0, attributedText.length)];
    
    [super setAttributedText:mAttributedText];
}

@end
