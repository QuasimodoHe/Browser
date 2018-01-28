//
//  HQClockModel.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/26.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQClockModel : NSObject
@property (nonatomic, strong) NSString *titleString;//标题
@property (nonatomic, strong) NSString *urlString;//链接
@property (nonatomic, strong) NSString *timeString;//时间戳
@property (nonatomic, assign) NSInteger repeatType;//重复类型
@property (nonatomic, assign) BOOL isOpen;//打开通知
@property (nonatomic, assign) NSInteger index;//第几个通知
@end
