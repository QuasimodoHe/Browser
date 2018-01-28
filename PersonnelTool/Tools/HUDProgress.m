//
//  HUDProgress.m
//  theNewGame
//
//  Created by  Quan He on 2017/5/16.
//  Copyright © 2017年 888. All rights reserved.
//

#import "HUDProgress.h"
@interface HUDProgress()
@property (strong, nonatomic) MBProgressHUD *hud;
@end
@implementation HUDProgress
+ (void)showTheInfo:(NSString *)infoString showTime:(CGFloat)time{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = infoString;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.opacity = 0.8;
    [window addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:time];
}

- (void)showTheHUD:(NSString *)infoString{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    self.hud = [[MBProgressHUD alloc]initWithView:window];
    self.hud.label.text = infoString;
    self.hud.contentColor = [UIColor whiteColor];
    self.hud.bezelView.color = [UIColor blackColor];
    self.hud.opacity = 0.8;
    [window addSubview:self.hud];
    [self.hud showAnimated:YES];
    
}
- (void)hideTheHUD{
    [self.hud hideAnimated:YES];
}
@end
