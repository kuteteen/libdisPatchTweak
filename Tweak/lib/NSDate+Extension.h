//
//  NSDate+MBExtension.h
//  mobogo
//
//  Created by LTZD on 14/10/14.
//  Copyright (c) 2014年 LTZD. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

#pragma mark -

@interface NSDate (Extension)

- (NSString *)stringWithDateFormat:(NSString *)format;

- (BOOL)isToday;
//- (NSString *)timeLeft;

//+ (long long)timeStamp;

+ (NSDate *)dateWithString:(NSString *)string;
//+ (NSDate *)now;


#pragma mark -
#pragma mark -  add by liu.shaoqiu at 2015年01月15日

#pragma mark - Class Method
+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (NSDate *)dateStartOfWeek;
+ (NSDate *)dateEndOfWeek;
//根据传入是时间格式跟时间字符串,获取NSDate对象
+ (NSDate *)dateWithString:(NSString *)string formatter:(NSString *)cFormatter;

#pragma mark - Public Method
    //TODO: NSDate对应值
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)weekday;
    //TODO: 每月的总天数和第一天是周几
- (NSInteger)numDaysInMonth;
- (NSInteger)firstWeekDayInMonth;
    //TODO: 日期相隔天,月,年的日期
- (NSDate *)offsetDay:(NSInteger)numDays;
- (NSDate *)offsetMonth:(NSInteger)numMonths;
- (NSDate *)offsetYear:(NSInteger)numYears;

- (NSDate *)monthIndexDay:(NSInteger)index;

- (NSString *)stringWithDateFormat:(NSString *)format locale:(NSString *)localeStr;

+ (NSString *)currentTimeMillis;

@end
