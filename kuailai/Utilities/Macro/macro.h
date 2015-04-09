//
//  Constant.h
//  TGod
//
//  Created by yangyang on 14/12/17.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

// 根据状态Log
#ifdef DEBUG
#   define YOSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define YOSLog(...)
#   define NSLog(...)
#endif

#define YOSIsIphone4                  ([[UIScreen mainScreen] bounds].size.height == 480)
#define YOSIsIphone5                  ([[UIScreen mainScreen] bounds].size.height == 568)
#define YOSIsIphone6                  ([[UIScreen mainScreen] bounds].size.width == 375)
#define YOSIsIphone6P                 ([[UIScreen mainScreen] bounds].size.height > 568)

#define YOSScreenWidth                [UIScreen mainScreen].bounds.size.width
#define YOSScreenHeight               [UIScreen mainScreen].bounds.size.height
#define YOSAutolayout(size)           (kScreenWidth / 320.0 * (size))
#define YOSAutolayoutHeight(size)     (kScreenHeight / 568 * (size))

#define YOSRGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define YOSRGB(r, g, b)                [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]

#define YOSFliterNil2String(data) ((data) ? (data) : @"")
