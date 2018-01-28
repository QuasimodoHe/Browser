//
//  HQClockManagerTool.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQClockManagerTool.h"

@implementation HQClockManagerTool
+ (void)addTheNewClock:(HQClockModel *)model{
    if ([self judgmentCanAddNotification]){//添加新通知
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.timeString longLongValue]];
        [self registerLocalNotification:date alertBody:model.titleString userDict:[self modelTrainToDic:model] repeatInterval:[self judgmentRepeatType:model.repeatType]];
        
        NSLog(@"推送添加成功\n\n");
        //添加本地缓存数据
        [HQDataManager addTheNewClockData:model];
        [HUDProgress showTheInfo:NSLocalizedString(@"推送提醒添加成功",nil) showTime:1.5];
    }
}

+ (void)changeTheClock:(HQClockModel *)model{
    if ([self judgmentCanAddNotification]){//修改通知
        //取消本地通知
        [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%ld",model.index]];
        //添加通知
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.timeString longLongValue]];
        [self registerLocalNotification:date alertBody:model.titleString userDict:[self modelTrainToDic:model] repeatInterval:[self judgmentRepeatType:model.repeatType]];
        //修改本地缓存数据
        [HQDataManager changeTheClockData:model];
        [HUDProgress showTheInfo:NSLocalizedString(@"推送提醒修改成功",nil) showTime:1.5];

    }

}
+ (void)removeTheClock:(HQClockModel *)model{
    //取消本地通知
    [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%ld",model.index]];
    //修改本地缓存数据
    [HQDataManager changeTheClockData:model];
    [HUDProgress showTheInfo:NSLocalizedString(@"推送提醒已关闭",nil) showTime:1.5];
}


+ (NSMutableDictionary *)modelTrainToDic:(HQClockModel *)model{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%ld",model.index] forKey:@"index"];
    [dic setObject:model.titleString forKey:@"titleString"];
    [dic setObject:model.urlString forKey:@"urlString"];
    return dic;
}

+ (NSCalendarUnit)judgmentRepeatType:(NSInteger)repeatType{
    switch (repeatType) {
        case 0:
            return 0;
            break;
        case 1:
            return NSCalendarUnitDay;
            break;
        case 2:
            return NSCalendarUnitWeekday;
            break;
        case 3:
            return NSCalendarUnitMonth;
            break;
            
        default:
            break;
    }
    return 0;
}

+ (BOOL)judgmentCanAddNotification{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {//推送设置,未开启推送
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
            return YES;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){//推送设置,未开启推送
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
            return YES;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
// 设置本地通知
+ (void)registerLocalNotification:(NSDate *)fireDate alertBody:(NSString *)alertBody userDict:(NSDictionary *)userDict repeatInterval:(NSCalendarUnit)repeatInterval
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = repeatInterval;
    
    // 通知内容
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber += 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    notification.userInfo = userDict;
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = repeatInterval;
    }
    else
    {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = repeatInterval;
    }
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key
{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications)
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo)
        {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"index"];
            
            // 如果找到需要取消的通知，则取消
            if ([info isEqualToString:key])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}
@end
