//
//  YOSLRLabel.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSLRLabel.h"

@implementation YOSLRLabel

- (void)setText:(NSString *)text {
    
    CGSize size = [text sizeWithAttributes:@{
                                             NSFontAttributeName:self.font,
                                             }];
    
    NSLog(@"size is \r\n : %@", NSStringFromCGSize(size));
    
    CGFloat characterSpace = (self.frame.size.width - size.width) / (text.length - 1);
    
    NSLog(@"%f ---", characterSpace);
    
    NSAttributedString *attributedString =[[NSAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName : @(characterSpace)}];
    
    self.lineBreakMode = NSLineBreakByClipping;
    [self setAttributedText:attributedString];
    
}

@end
