//
//  HQCacheData.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/22.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "HQCacheData.h"

@implementation HQCacheData
static HQCacheData *cacheData;

+ (HQCacheData *)shareInstance{
    @synchronized(self) {
        if (cacheData == nil) {
            cacheData = [[self alloc] init];
            cacheData.homeModelArr = [[NSMutableArray alloc]init];
            cacheData.homeUrl = [cacheData readTheUserInfo];
        }
    }
    return cacheData;
}

- (NSMutableArray *)homeModelArr{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[HQDataManager readTheHomeData]];
    NSMutableArray *a = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in arr) {
        HomeCollectionModel *model = [[HomeCollectionModel alloc] init];
        model.imageUrl = dic[@"imageUrl"];
        model.titleString = dic[@"title"];
        model.targetUrl = dic[@"urlString"];
        model.isHomeUrl = [dic[@"isHomeUrl"] boolValue];
        if ([dic[@"isHomeUrl"] boolValue]){
            [HQCacheData shareInstance].homeUrl = model.targetUrl;
        }
        [a addObject:model];
    }
    return a;
}

- (void)setHomeUrl:(NSString *)homeUrl{
    _homeUrl = homeUrl;
    [self writeTheUserInfo:homeUrl];
}

- (NSString *)readTheUserInfo{
    NSUserDefaults *userDef =[NSUserDefaults standardUserDefaults];
    NSDictionary *user = [userDef objectForKey:@"userInfo"];
    if (user){
        return user[@"homeUrl"];
    }
    return @"";
}

- (void)writeTheUserInfo:(NSString *)url{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSUserDefaults *userDef =[NSUserDefaults standardUserDefaults];
    NSDictionary *loginUserinfo = @{@"homeUrl" :url};
    [userDef setObject:loginUserinfo forKey:@"userInfo"];
    [userDef synchronize];
}
@end
