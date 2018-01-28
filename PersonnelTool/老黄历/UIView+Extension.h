//
//  UIView+TAExtension.h
//  CommunityFinancial
//
//  Created by wuxiyao on 15/10/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIView类别扩展
@interface UIView (TAExtension)

#pragma mark - autoLayout

@property (assign, nonatomic) CGFloat layout_y;
@property (assign, nonatomic) CGFloat layout_x;
@property (assign, nonatomic) CGPoint layout_min_origin;

@property (assign, nonatomic) CGFloat layout_height;
@property (assign, nonatomic) CGFloat layout_width;
@property (assign, nonatomic) CGSize  layout_size;

@property (assign, nonatomic) CGFloat layout_center_x;
@property (assign, nonatomic) CGFloat layout_center_y;
@property (assign, nonatomic) CGPoint layout_center;

@property (assign, nonatomic) CGFloat layout_max_y;
@property (assign, nonatomic) CGFloat layout_max_x;
@property (assign, nonatomic) CGPoint layout_max_origin;

@property (assign, nonatomic) CGFloat layout_top;
@property (assign, nonatomic) CGFloat layout_bottom;
@property (assign, nonatomic) CGFloat layout_left;
@property (assign, nonatomic) CGFloat layout_right;

#pragma mark - 获得view的父视图控制器

- (UIViewController *)getViewSuperViewController;

- (void) changeAnchorPoint:(CGFloat)aX :(CGFloat)aY toPoint:(CGFloat)tX :(CGFloat)tY;

@end
