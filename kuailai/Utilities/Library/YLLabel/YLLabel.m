//
//  YLLabel.m
//  YLLabelDemo
//
//  Created by Eric Yuan on 12-11-8.
//  Copyright (c) 2012年 YuanLi. All rights reserved.
//

#import "YLLabel.h"
#import <CoreText/CoreText.h>

@interface YLLabel(Private)

@property (nonatomic, assign) CGSize size;

- (void)formatString;

@end

@implementation YLLabel

@synthesize font = _font;
@synthesize textColor = _textColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self formatString];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);

    CGContextTranslateCTM(ctx,0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_string);
    
    CGRect bounds = self.bounds;
    bounds.origin.x = bounds.origin.x + 8;
    bounds.size.width = bounds.size.width - 16;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [_string length]), path, NULL);
    CFRelease(path);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
    CFRelease(frameSetter);
}

- (void)setText:(NSString *)text
{
    _string = [[NSMutableAttributedString alloc] initWithString:text];
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}

- (void)formatString
{
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CGFloat paragraphSpacing = 11.0;
    CGFloat paragraphSpacingBefore = 0.0;
    CGFloat firstLineHeadIndent = 0.0;
    CGFloat headIndent = 0.0;
    CGFloat lineSpace = 5.0;
    
    CTParagraphStyleSetting settings[] =
    {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
        {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
        {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
    };
    
    CTParagraphStyleRef style;
    style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(CTParagraphStyleSetting));
    
    if (NULL == style) {
        // error...
        return;
    }

    [_string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)style, (NSString*)kCTParagraphStyleAttributeName, nil]
                     range:NSMakeRange(0, [_string length])];

    CFRelease(style);

    if (nil == _font) {
        _font = [UIFont boldSystemFontOfSize:12.0];
    }

    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)_font.fontName, _font.pointSize, NULL);
    [_string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge UIFont*)fontRef, (NSString*)kCTFontAttributeName, nil]
                     range:NSMakeRange(0, [_string length])];
    
    
    
    CGColorRef colorRef = _textColor.CGColor;
    [_string addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)colorRef,(NSString*)kCTForegroundColorAttributeName, nil]
                     range:NSMakeRange(0, [_string length])];
}

- (CGSize)size {
    
    NSMutableAttributedString *mAttributedString = [_string mutableCopy];
    
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CGFloat paragraphSpacing = 11.0;
    CGFloat paragraphSpacingBefore = 0.0;
    CGFloat firstLineHeadIndent = 0.0;
    CGFloat headIndent = 0.0;
    CGFloat lineSpace = 5.0;
    
    CTParagraphStyleSetting settings[] =
    {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
        {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
        {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
    };
    
    CTParagraphStyleRef style;
    style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(CTParagraphStyleSetting));
    
    [mAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)style, (NSString*)kCTParagraphStyleAttributeName, nil]
                     range:NSMakeRange(0, [mAttributedString length])];
    
    if (nil == _font) {
        _font = [UIFont boldSystemFontOfSize:12.0];
    }
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)_font.fontName, _font.pointSize, NULL);
    [mAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge UIFont*)fontRef, (NSString*)kCTFontAttributeName, nil]
                     range:NSMakeRange(0, [mAttributedString length])];
    
    CGColorRef colorRef = _textColor.CGColor;
    [mAttributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)colorRef,(NSString*)kCTForegroundColorAttributeName, nil]
                     range:NSMakeRange(0, [mAttributedString length])];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)mAttributedString);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge NSObject*)style, (NSString*)kCTParagraphStyleAttributeName, (__bridge UIFont*)fontRef, kCTFontAttributeName, nil];

    // yy：-16 是因为上面 -6是因为self.bounds，-6 DetailVC中比父控件左右有3的margin
    /*
    CGRect bounds = self.bounds;
    bounds.origin.x = bounds.origin.x + 8;
    bounds.size.width = bounds.size.width - 16;
     */
    CFRange range;
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, mAttributedString.length), (__bridge CFDictionaryRef)dict, CGSizeMake(YOSScreenWidth - 16 - 6, MAXFLOAT), &range);

    size.width = ceil(size.width) + 16;
    size.height = ceil(size.height);
    
    return size;
}

@end
