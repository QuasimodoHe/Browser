//
//  HuangAlmanacModel.h
//  LotteryProject
//
//  Created by Mac on 2018/1/19.
//  Copyright © 2018年 LisztCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuangAlmanacModel : NSObject

@property(strong, nonatomic)NSString * year;	//string	年
@property(strong, nonatomic)NSString * month;   //	string	月
@property(strong, nonatomic)NSString * day;     //	string	日
@property(strong, nonatomic)NSString * yangli;      //string	阳历
@property(strong, nonatomic)NSString * nongli;      //string	农历
@property(strong, nonatomic)NSString * star;        //string	星座
@property(strong, nonatomic)NSString * taishen;     //string	胎神
@property(strong, nonatomic)NSString * wuxing;      //string	五行
@property(strong, nonatomic)NSString * chong;       //string	冲
@property(strong, nonatomic)NSString * sha;     //string	煞
@property(strong, nonatomic)NSString * shengxiao;       //string	生肖
@property(strong, nonatomic)NSString * jiri;        //string	吉日
@property(strong, nonatomic)NSString * zhiri;       //string	值日天神
@property(strong, nonatomic)NSString * xiongshen;       //string	凶神
@property(strong, nonatomic)NSString * jishenyiqu;      //string	吉神宜趋
@property(strong, nonatomic)NSString * caishen;     //string	财神
@property(strong, nonatomic)NSString * xishen;      //string	喜神
@property(strong, nonatomic)NSString * fushen;      //string	福神
@property(strong, nonatomic)NSArray * suici;        //string	岁次
@property(strong, nonatomic)NSArray * yi;       //string	宜
@property(strong, nonatomic)NSArray * ji;       //string	忌
@property(strong, nonatomic)NSString * eweek;       //string	英文星期
@property(strong, nonatomic)NSString * emonth;      //string	英文月
@property(strong, nonatomic)NSString * week;        //string	星期

@end
