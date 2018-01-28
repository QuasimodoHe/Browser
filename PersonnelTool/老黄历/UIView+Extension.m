//
//  UIView+TAExtension.m
//  CommunityFinancial
//
//  Created by wuxiyao on 15/10/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (TAExtension)

#pragma mark - autoLayout

- (CGFloat)layout_y
{
    return self.frame.origin.y;
}

- (void)setLayout_y:(CGFloat)layout_y
{
    CGRect temp = self.frame;
    temp.origin.y = layout_y;
    self.frame = temp;
}

- (CGFloat)layout_x
{
    return self.frame.origin.x;
}

- (void)setLayout_x:(CGFloat)layout_x
{
    CGRect temp = self.frame;
    temp.origin.x = layout_x;
    self.frame = temp;
}

- (void)setLayout_min_origin:(CGPoint)layout_min_origin
{
    CGRect temp = self.frame;
    temp.origin = layout_min_origin;
    self.frame = temp;
}

- (CGPoint)layout_min_origin
{
    return self.frame.origin;
}

- (CGFloat)layout_height
{
    return self.frame.size.height;
}

- (void)setLayout_height:(CGFloat)layout_height
{
    CGRect temp = self.frame;
    temp.size.height = layout_height;
    self.frame = temp;
}

- (CGFloat)layout_width
{
    return self.frame.size.width;
}

- (void)setLayout_width:(CGFloat)layout_width
{
    CGRect temp = self.frame;
    temp.size.width = layout_width;
    self.frame = temp;
}

- (void)setLayout_size:(CGSize)layout_size
{
    CGRect temp = self.frame;
    temp.size = layout_size;
    self.frame = temp;
}

- (CGSize)layout_size
{
    return self.frame.size;
}

- (CGFloat)layout_center_x
{
    return self.center.x;
}

- (void)setLayout_center_x:(CGFloat)layout_center_x
{
    CGPoint center = self.center;
    center.x = layout_center_x;
    self.center = center;
}

- (CGFloat)layout_center_y
{
    return self.center.y;
}

- (void)setLayout_center_y:(CGFloat)layout_center_y
{
    CGPoint center = self.center;
    center.y = layout_center_y;
    self.center = center;
}

- (void) setLayout_center:(CGPoint)layout_center
{
    CGPoint temp = self.center;
    temp = layout_center;
    self.center = temp;
}

- (CGPoint) layout_center
{
    return self.center;
}

- (void)setLayout_max_x:(CGFloat)layout_max_x
{
    CGRect temp = self.frame;
    temp.origin.x = layout_max_x - self.frame.size.width;
    self.frame = temp;
}

- (CGFloat) layout_max_x
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)layout_max_y
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLayout_max_y:(CGFloat)layout_max_y
{
    CGRect temp = self.frame;
    temp.origin.y = layout_max_y - self.frame.size.height;
    self.frame = temp;
}

- (CGPoint) layout_max_origin
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

- (void) setLayout_max_origin:(CGPoint)layout_max_origin
{
    CGRect temp = self.frame;
    temp.origin.y = layout_max_origin.y - self.frame.size.height;
    temp.origin.x = layout_max_origin.x - self.frame.size.width;
    self.frame = temp;
}

- (CGFloat) layout_top
{
    return self.frame.origin.y;
}

- (void) setLayout_top:(CGFloat)layout_top
{
    CGRect frame = self.frame;
    frame.origin.y = layout_top;
    self.frame = frame;
}

- (CGFloat) layout_left
{
    return self.frame.origin.x;
}

- (void) setLayout_left:(CGFloat)layout_left
{
    CGRect frame = self.frame;
    frame.origin.x = layout_left;
    self.frame = frame;
}

- (CGFloat) layout_bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void) setLayout_bottom:(CGFloat)layout_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = layout_bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat) layout_right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void) setLayout_right:(CGFloat)layout_right
{
    CGRect frame = self.frame;
    frame.origin.x = layout_right - self.frame.size.width;
    self.frame = frame;
}

#pragma mark - 获得view的父视图控制器

- (UIViewController *)getViewSuperViewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//根据锚点布局view的frame

- (void) changeAnchorPoint:(CGFloat)aX :(CGFloat)aY toPoint:(CGFloat)tX :(CGFloat)tY {
    CGRect frame = self.frame;
    frame.origin.x = tX - frame.size.width * aX;
    frame.origin.y = tY - frame.size.height * aY;
    self.frame = frame;
}

@end
