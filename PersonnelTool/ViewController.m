//
//  ViewController.m
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/21.
//  Copyright © 2018年 gd. All rights reserved.
//

#import "ViewController.h"
#import "HQHomeViewController.h"
@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *a;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"home.plist"];
    
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableArray *data2 = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    if (!data2){
        [HQCacheData shareInstance].isFirst = YES;
    }
    self.a = [HQCacheData shareInstance].homeModelArr;
    HQHomeViewController *home = [[HQHomeViewController alloc]init];
    [UIApplication sharedApplication].delegate.window.rootViewController = home;//加载原本页面
//    NSLog(@"%@",[HQDataManager readTheClockData]);
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications)
    {
        NSDictionary *userInfo = notification.userInfo;
        NSLog(@"userInfo:  %@",userInfo);
    }
    [HQDataManager reloadTheClockData];

}


@end
