//
//  CalendarAssistant.h
//  LotteryProject
//
//  Created by Mac on 2018/1/19.
//  Copyright © 2018年 LisztCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarAssistant : NSObject

+ (NSCalendar *)localCalendar;
+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year;
+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;
+ (NSDate *)dateFromComponents:(NSDateComponents *)components;
+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year;
+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year;
+ (NSString *)stringOfWeekdayInEnglish:(NSUInteger)weekday;
+ (NSString *)stringOfMonthInEnglish:(NSUInteger)month;
+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;
+ (BOOL)isDateTodayWithDateComponents:(NSDateComponents *)dateComponents;
+ (NSString *)weekCnStringFromDate:(NSDate *)date;
+ (NSString *)monthEnStringFromDate:(NSDate *)date;
+ (NSDate *)dateFormYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

@end

@interface NSDate (Extension)

@property (strong, nonatomic, readonly) NSDateComponents *components;

- (NSDate *)dateForUnit:(NSCalendarUnit)unit value:(NSInteger)value;

@end
