//
//  CalendarAssistant.m
//  LotteryProject
//
//  Created by Mac on 2018/1/19.
//  Copyright © 2018年 LisztCoder. All rights reserved.
//

#import "CalendarAssistant.h"

@implementation CalendarAssistant

+ (NSCalendar *)localCalendar {
    static NSCalendar *Instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Instance = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    return Instance;
}

+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year {
    return [self dateWithMonth:month day:1 year:year];
}

+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    
    return [self dateFromComponents:comps];
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components {
    return [[self localCalendar] dateFromComponents:components];
}

+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [self dateWithMonth:month year:year];
    return [[self localCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [self dateWithMonth:month year:year];
    return [[self localCalendar] component:NSCalendarUnitWeekday fromDate:date];
}

+ (NSString *)stringOfWeekdayInEnglish:(NSUInteger)weekday {
    NSAssert(weekday >= 1 && weekday <= 7, @"Invalid weekday: %lu", (unsigned long) weekday);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Strings = @[@"Sun", @"Mon", @"Tues", @"Wed", @"Thur", @"Fri", @"Sat"];
        Strings = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    });
    
    return Strings[weekday - 1];
}

+ (NSString *)stringOfMonthInEnglish:(NSUInteger)month {
    NSAssert(month >= 1 && month <= 12, @"Invalid month: %lu", (unsigned long) month);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Strings = @[@"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May.", @"Jun.", @"Jul.", @"Aug.", @"Sept.", @"Oct.", @"Nov.", @"Dec."];
        Strings = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    });
    
    return Strings[month - 1];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [[self localCalendar] components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitQuarter|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitNanosecond|NSCalendarUnitCalendar|NSCalendarUnitTimeZone) fromDate:date];
}

+ (BOOL)isDateTodayWithDateComponents:(NSDateComponents *)dateComponents {
    NSDateComponents *todayComps = [self dateComponentsFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    return todayComps.year == dateComponents.year && todayComps.month == dateComponents.month && todayComps.day == dateComponents.day;
}

+ (NSString *)weekCnStringFromDate:(NSDate *)date {
    NSArray *weeks = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"];
    NSString *weekCNString = weeks[date.components.weekday];
    return weekCNString;
}

+ (NSString *)monthEnStringFromDate:(NSDate *)date {
    NSArray *months= @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
    NSString *monthEnString = months[date.components.month];
    return monthEnString;
}

+ (NSDate *)dateFormYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    return [[self localCalendar] dateFromComponents:components];
}

@end

@implementation NSDate (Extension)

- (NSDateComponents *)components {
    if (self != nil) {
        NSDateComponents *components = [CalendarAssistant dateComponentsFromDate:self];
        return components;
    }
    return nil;
}

- (NSDate *)dateForUnit:(NSCalendarUnit)unit value:(NSInteger)value{
    NSInteger year = unit == NSCalendarUnitYear ? value : self.components.year;
    NSInteger month = unit == NSCalendarUnitMonth ? value : self.components.month;
    NSInteger day = unit == NSCalendarUnitDay ? value : self.components.day;
    NSInteger hour = unit == NSCalendarUnitHour ? value : self.components.hour;
    NSInteger minute = unit == NSCalendarUnitMinute ? value : self.components.minute;
    NSInteger second = unit == NSCalendarUnitSecond ? value : self.components.second;
    NSDate *date = [CalendarAssistant dateFormYear:year month:month day:day hour:hour minute:minute second:second];
    if (date) {
        return date;
    }
    return nil;
}


@end
