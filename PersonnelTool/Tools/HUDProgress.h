//
//  HUDProgress.h
//  theNewGame
//
//  Created by  Quan He on 2017/5/16.
//  Copyright © 2017年 888. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDProgress : NSObject
+ (void)showTheInfo:(NSString *)infoString showTime:(CGFloat)time;
- (void)showTheHUD:(NSString *)infoString;
- (void)hideTheHUD;
@end
