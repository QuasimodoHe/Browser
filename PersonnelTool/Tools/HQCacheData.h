//
//  HQCacheData.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/22.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQCacheData : NSObject
+ (HQCacheData *)shareInstance;
@property (nonatomic,strong) NSMutableArray *homeModelArr;
@property (nonatomic,strong) NSString *homeUrl;
@property (nonatomic,assign) BOOL isFirst;//是否第一次安装
@end
