//
//  YOSLRLabel.m
//  kuailai
//
//  Created by yangyang on 15/4/14.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSLRLabel.h"

@implementation YOSLRLabel

/**
 *  特别注意：这里一定需要self.frame.size.width已经有值(非0)
 *
 *  @param text <#text description#>
 */
- (void)setText:(NSString *)text {
    
    NSAssert((BOOL)self.frame.size.width, @"fatal error: self.frame.size.width must not be zero.");
    
    CGSize size = [text sizeWithAttributes:@{
                                             NSFontAttributeName:self.font,
                                             }];
    
//    YOSLog(@"\r\n size is \r\n : %@", NSStringFromCGSize(size));
//    YOSLog(@"\r\n size is \r\n : %@", NSStringFromCGSize(self.frame.size));
    
    CGFloat characterSpace = (self.frame.size.width - size.width) / (text.length - 1);
    
    NSAttributedString *attributedString =[[NSAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName : @(characterSpace)}];
    
    self.lineBreakMode = NSLineBreakByClipping;
    [self setAttributedText:attributedString];
    
}

@end
