//
//  YOSTextView.m
//  kuailai
//
//  Created by yangyang on 15/5/10.
//  Copyright (c) 2015年 kuailai.inc. All rights reserved.
//

#import "YOSTextView.h"
#import "EDColor.h"

@interface YOSTextView ()

@end

@implementation YOSTextView {
    NSString *_placeholder;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.font = [UIFont systemFontOfSize:14.0f];
    self.textColor = [UIColor colorWithHexString:@"#2c2b2a"];
    self.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 0);
    
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    NSLog(@"%s", __func__);

    if (!self.text.length) {
        [_placeholder drawInRect:CGRectMake(14, 10, 250, 14.5) withAttributes:@{
                                                                                NSFontAttributeName : self.font,
                                                                                NSForegroundColorAttributeName : YOSColorFontGray
                                                                                }];
    }
    
}

#pragma mark - private method

// no used.
- (CGSize)sizeWithString:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake(self.contentSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
}

// no used.
- (NSDictionary *)attributesWithColor:(UIColor *)color {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    
    style.lineSpacing = 30;
    style.maximumLineHeight = 44.f;
    style.minimumLineHeight = 44.f;
    
    return @{
             NSForegroundColorAttributeName : color,
             NSFontAttributeName : self.font,
             NSParagraphStyleAttributeName : style,
             };
}


@end
