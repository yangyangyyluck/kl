//
//  UIView+YOSAdditions.h
//
//  Created by yangyangyyluck on 14-5-5.
//  Copyright (c) 2013年 LASHOU-INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YOSAdditions)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat yos_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat yos_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat yos_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat yos_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat yos_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat yos_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat yos_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat yos_centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat yos_screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat yos_screenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat yos_screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat yos_screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect yos_screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint yos_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize yos_size;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat yos_orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat yos_orientationHeight;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)yos_descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)yos_ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)yos_removeAllSubviews;

/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)yos_offsetFromView:(UIView*)otherView;

@property (nonatomic, retain) id yos_attachment; //在视图中附加一个绑定数据

@property (nonatomic, strong) id yos_attachment2;

/** deep copy self */
- (instancetype)yos_copySelf;

- (UIViewController *)yos_viewController;

- (UIView *)yos_topestSuperview;

@end
