//
//  HQDataManager.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/21.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQDataManager.h"
@interface HQDataManager()

@end
@implementation HQDataManager
+ (NSMutableArray *)readTheHomeData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"home.plist"];
    
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableArray *data2 = [[NSMutableArray alloc] initWithContentsOfFile:filename];
//    NSLog(@"fileData : %@",data2);
    if (!data2){
        data2 = [[NSMutableArray alloc]init];
        [data2 addObject:[self nullDic]];
        [self writeTheHomeData:data2];
    }
    return data2;
}
+ (void)writeTheHomeData:(NSMutableArray *)arr{
//    NSLog(@"writeTheHomeData : %@",arr);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"home.plist"];
    [arr writeToFile:filename atomically:YES];
}

+ (void)addTheNewHomeData:(NSMutableDictionary *)dic{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[self readTheHomeData]];
    [arr insertObject:dic atIndex:0];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    if ([dic[@"isHomeUrl"] isEqualToString:@"1"]){
        for (NSInteger index = 0;index < arr.count;index ++){
            NSDictionary *dataDic = arr[index];
            if (index != 0){
                [dataDic setValue:@"0" forKey:@"isHomeUrl"];
            }
            [arr1 addObject:dataDic];
        }
        [self writeTheHomeData:arr1];
    }else{
        [self writeTheHomeData:arr];
    }
}

+ (void)changeTheHomeData:(NSMutableDictionary *)dic index:(NSInteger)index{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[self readTheHomeData]];
    [arr replaceObjectAtIndex:index withObject:dic];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    if ([dic[@"isHomeUrl"] isEqualToString:@"1"]){
        for (NSInteger index1 = 0;index1 < arr.count;index1 ++){
            NSDictionary *dataDic = arr[index1];
            if (index1 != index){
                [dataDic setValue:@"0" forKey:@"isHomeUrl"];
            }
            [arr1 addObject:dataDic];
        }
        [self writeTheHomeData:arr1];
    }else{
        [self writeTheHomeData:arr];
    }
}

+ (void)deleteTheHomeDataWithIndex:(NSInteger)index{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[self readTheHomeData]];
    NSDictionary *dic = arr[index];
    if ([dic[@"isHomeUrl"] isEqualToString:@"1"]){
        if (arr.count >= 2){
            NSDictionary *dic = [arr objectAtIndex:1];
            [dic setValue:@"1" forKey:@"isHomeUrl"];
            [arr replaceObjectAtIndex:1 withObject:dic];
        }
    }
    [arr removeObjectAtIndex:index];
    [self writeTheHomeData:arr];
}

+ (NSDictionary *)nullDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:NSLocalizedString(@"添加",nil) forKey:@"title"];
    [dic setObject:@"null" forKey:@"urlString"];
    [dic setObject:@"add" forKey:@"imageUrl"];
    [dic setObject:@"0" forKey:@"isHomeUrl"];
    return dic;
}

//闹钟数据
+ (NSMutableArray *)readTheClockData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"clock.plist"];
    
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableArray *data2 = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    if (!data2){
        data2 = [[NSMutableArray alloc]init];
    }
    return data2;
}
+ (void)writeTheClockData:(NSMutableArray *)arr{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"clock.plist"];
    [arr writeToFile:filename atomically:YES];
}

+ (void)addTheNewClockData:(HQClockModel *)model{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[self readTheClockData]];
    [arr addObject:[self clockModelTrainToDic:model]];
    [self writeTheClockData:arr];
}
+ (void)changeTheClockData:(HQClockModel *)model{//修改闹钟数据
    [self changeTheClockData:[self clockModelTrainToDic:model] index:model.index];
}

+ (void)changeTheClockData:(NSMutableDictionary *)dic index:(NSInteger)index{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[self readTheClockData]];
    [arr replaceObjectAtIndex:index withObject:dic];
    [self writeTheClockData:arr];
}

+ (void)deleteTheClockData:(HQClockModel *)model{//删除闹钟
    [self deleteTheClockDataWithIndex:model.index];
}

+ (void)closeTheClockData:(HQClockModel *)model{//关闭闹钟
    [self changeTheClockData:model];
}

+ (void)deleteTheClockDataWithIndex:(NSInteger)index{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[self readTheClockData]];
    for (NSInteger index1 = 0;index1 < arr.count;index1 ++){
        NSDictionary *dic = arr[index1];
        if ([dic[@"index"] integerValue] == index){
            [arr removeObjectAtIndex:index1];
        }
    }
    [self writeTheClockData:arr];
}

+ (NSMutableDictionary *)clockModelTrainToDic:(HQClockModel *)model{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:model.titleString forKey:@"titleString"];
    [dic setObject:model.urlString forKey:@"urlString"];
    [dic setObject:model.timeString forKey:@"timeString"];
    [dic setObject:[NSString stringWithFormat:@"%ld",model.repeatType] forKey:@"repeatType"];
    [dic setObject:[NSString stringWithFormat:@"%ld",model.index] forKey:@"index"];
    [dic setObject:[NSString stringWithFormat:@"%d",model.isOpen] forKey:@"isOpen"];
    return dic;
}

+ (void)reloadTheClockData{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[HQDataManager readTheClockData]];
    //如果推送时间超过了现在的时间且是不重复推送则进行数据修改
    
    for (NSInteger index = 0;index < array.count;index ++){        
        NSMutableDictionary *dic = array[index];
        if([dic[@"timeString"] integerValue] < (long)[[NSDate date] timeIntervalSince1970]){
            [dic setObject:@"0" forKey:@"isOpen"];
            [HQClockManagerTool cancelLocalNotificationWithKey:dic[@"index"]];
        }
        [array replaceObjectAtIndex:index withObject:dic];
    }
    [self writeTheClockData:array];
}
@end
