//
//  HQClockManagerTool.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQClockManagerTool : NSObject
+ (void)addTheNewClock:(HQClockModel *)model;//添加闹钟提醒
+ (void)changeTheClock:(HQClockModel *)model;//修改闹钟
+ (void)removeTheClock:(HQClockModel *)model;//关闭闹钟
+ (void)cancelLocalNotificationWithKey:(NSString *)key;
@end
