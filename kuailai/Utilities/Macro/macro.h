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

#define kIsIphone4                  ([[UIScreen mainScreen] bounds].size.height == 480)

#define kIsIphone5                  ([[UIScreen mainScreen] bounds].size.height == 568)
#define kIsIphone6P                 ([[UIScreen mainScreen] bounds].size.height > 568)
#define kIsIphone6                  ([[UIScreen mainScreen] bounds].size.width == 375)

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height
#define kAutolayout(size)           (kScreenWidth / 320.0 * (size))
#define kAutolayoutHeight(size)     (kScreenHeight / 568 * (size))

#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r, g, b)                [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]

