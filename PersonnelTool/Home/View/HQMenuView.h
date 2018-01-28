//
//  HQMenuView.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HQMenuViewDelegate <NSObject>
- (void)addKuaiJianVCAction;
- (void)addClockVCAction;
- (void)huangliAction;
- (void)clearTheCache;
- (void)closeMenuView;
@end
@interface HQMenuView : UIView
@property (nonatomic, weak) id <HQMenuViewDelegate>delegate;

@end
