//
//  PrefixHeader.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/21.
//  Copyright © 2018年 gd. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#define KWidth [UIScreen mainScreen].bounds.size.width//屏幕宽
#define KHeight [UIScreen mainScreen].bounds.size.height//屏幕高
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define KSafeTopHeight (IS_IPHONE_X?24:0)
#define KSafeBottumHeight (IS_IPHONE_X?34:0)

#define navHeight (64+KSafeTopHeight)
#define KTabBarHeight (49+KSafeBottumHeight)

#define bili [UIScreen mainScreen].bounds.size.width/375


#define VCBackColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f]//控制器背景色

#define tabBarTitleHightColor [UIColor colorWithRed:0.73f green:0.15f blue:0.01f alpha:1.00f]//标签栏选中颜色
#define tabBarTitleNormalColor [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f]//标签栏未选择颜色
#define tabBarBackColor [UIColor whiteColor]//标签背景色

#define navBarTintColor [UIColor colorWithRed:1.00f green:0.15f blue:0.20f alpha:1.00f];//头部背景色
#define navBarTitleColor [UIColor whiteColor] //标题颜色

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define TopHeightIs (IS_IPHONE_X?44:20)
#define BottomHeightIs (IS_IPHONE_X?24:0)


#import "SDAutoLayout.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


#import "HQBaseViewController.h"
#import "HQBaseSetViewController.h"
#import "HomeCollectionModel.h"
#import "HQDataManager.h"
#import "HQCacheData.h"
#import "UIImage+UIImageExtras.h"
#import "ToolsMath.h"
#import "HUDProgress.h"


#import "HQClockModel.h"
#import "HQClockManagerTool.h"
#endif /* PrefixHeader_h */
