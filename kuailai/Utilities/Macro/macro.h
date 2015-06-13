//
//  Constant.h
//  TGod
//
//  Created by yangyang on 14/12/17.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

// 根据状态Log
#ifdef DEBUG
    #define YOSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define YOSLog(...)
    #define NSLog(...)
#endif


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define CURRENTSYSTEM  [[[UIDevice currentDevice] systemVersion] floatValue]


#define YOSIsIphone4                  ([[UIScreen mainScreen] bounds].size.height == 480)
#define YOSIsIphone5                  ([[UIScreen mainScreen] bounds].size.height == 568)
#define YOSIsIphone6                  ([[UIScreen mainScreen] bounds].size.width == 375)
#define YOSIsIphone6P                 ([[UIScreen mainScreen] bounds].size.width == 414)


#define YOSScreenWidth                [UIScreen mainScreen].bounds.size.width
#define YOSScreenHeight               [UIScreen mainScreen].bounds.size.height
#define YOSAutolayout(size)           (YOSScreenWidth / 320.0 * (size))
#define YOSAutolayoutHeight(size)     (YOSScreenHeight / 568 * (size))


#define YOSRGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define YOSRGB(r, g, b)                [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]
#define YOSColorRandom                YOSRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define YOSColorGreen                  YOSRGB(69, 198, 157)
#define YOSColorGray                   YOSRGB(228, 228, 228)
#define YOSColorBackgroundGray         YOSRGB(239, 239, 244)
#define YOSColorMainRed                YOSRGB(255, 105, 58)
#define YOSColorFontGray                [UIColor colorWithHexString:@"#858585"]
#define YOSColorFontBlack               [UIColor colorWithHexString:@"#2c2b2a"]
#define YOSColorLineGray                [UIColor colorWithHexString:@"#e5e5e5"]

#define YOSFontBig                      [UIFont systemFontOfSize:15.0f]
#define YOSFontNormal                   [UIFont systemFontOfSize:14.0f]
#define YOSFontSmall                    [UIFont systemFontOfSize:12.0f]


#define YOSFliterNil2String(data) ((data) ? (data) : @"")
#define YOSFliterPHPNull2String (([data isKindOfClass:[NSString class]] && [(NSString *)data isEqualToString:@"<null>"] ? @"" : data))


#define YOSWSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define YOSSSelf(strongSelf)  __strong __typeof(&*self)strongSelf = self
#define YOSWObject(object, weakObject)  __weak __typeof(&*object)weakObject = object
#define YOSSObject(object, strongObject)  __strong __typeof(&*object)strongObject = object
