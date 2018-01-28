//
//  HQDataManager.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/21.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQClockModel.h"
@interface HQDataManager : NSObject
//首页数据
+ (NSMutableArray *)readTheHomeData;
+ (void)writeTheHomeData:(NSMutableArray *)arr;
+ (void)addTheNewHomeData:(NSMutableDictionary *)dic;
+ (void)changeTheHomeData:(NSMutableDictionary *)dic index:(NSInteger)index;
+ (void)deleteTheHomeDataWithIndex:(NSInteger)index;
//闹钟数据
+ (NSMutableArray *)readTheClockData;
+ (void)addTheNewClockData:(HQClockModel *)model;//添加新的闹钟提醒

+ (void)changeTheClockData:(HQClockModel *)model;//修改闹钟
+ (void)deleteTheClockData:(HQClockModel *)model;//删除闹钟
+ (void)closeTheClockData:(HQClockModel *)model;//关闭闹钟

+ (void)reloadTheClockData;//重置通知数据
@end
