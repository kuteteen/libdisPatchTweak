//
//  NSDate+MBExtension.m
//  mobogo
//
//  Created by LTZD on 14/10/14.
//  Copyright (c) 2014年 LTZD. All rights reserved.
//

#import "NSDate+Extension.h"


@implementation NSDate(Extension)

+ (NSDate *)dateWithString:(NSString *)string {
	
	if (string == nil || [@"" isEqualToString:string]) {
		return [NSDate date];
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *reval = [formatter dateFromString:string];

	return reval;
}

- (BOOL)isToday{
    NSDate *todayDate = [NSDate date];
    if (self.year==todayDate.year &&
        self.month==todayDate.month &&
        self.day==todayDate.day) {
        return YES;
    }else{
        return NO;
    }
}


- (NSString *)stringWithDateFormat:(NSString *)format {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *reval =[formatter stringFromDate:self];
	
	return reval;
}

#pragma mark - 本地化时间格式,add by liu.shaoqiu at 2015年01月26日
- (NSString *)stringWithDateFormat:(NSString *)format locale:(NSString *)localeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeStr]];
    NSString *reval =[formatter stringFromDate:self];
    
    return reval;
}

#pragma mark -
#pragma mark -  add by liu.shaoqiu at 2015年01月15日

#pragma mark - Class Method
+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    return [gregorian dateFromComponents:components];
}
+ (NSDate *)dateStartOfWeek {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:1];  //默认1为sunday, 2 设置monday为第一天
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-((([components weekday]-[gregorian firstWeekday])+7)%7)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    NSDateComponents *componentsStripped = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:componentsStripped];
    return beginningOfWeek;
}
+ (NSDate *)dateEndOfWeek {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: - (((([components weekday] - [gregorian firstWeekday])
                                  + 7 ) % 7))+6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                        fromDate: endOfWeek];
    
    //gestript
    endOfWeek = [gregorian dateFromComponents: componentsStripped];
    return endOfWeek;
}
//根据传入是时间格式跟时间字符串,获取NSDate对象
+ (NSDate *)dateWithString:(NSString *)string formatter:(NSString *)cFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:cFormatter];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

#pragma mark - Public Method
//TODO: NSDate对应值
- (NSInteger)year {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:self];
    return [components year];
}
- (NSInteger)month {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}
- (NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:self];
    return [components day];
}
- (NSInteger)hour {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}
- (NSInteger)minute {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}
- (NSInteger)second {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}
- (NSInteger)weekday {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

    //TODO:每月的总天数和第一天是周几
- (NSInteger)numDaysInMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDayInMonth = range.length;
    return numberOfDayInMonth;
}
- (NSInteger)firstWeekDayInMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:1];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    [components setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:components];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekday forDate:newDate];
}

    //TODO: 日期相隔天,月,年的日期
- (NSDate *)offsetDay:(NSInteger)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:1];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
    
}
- (NSDate *)offsetMonth:(NSInteger)numMonths {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:1];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}
- (NSDate *)offsetYear:(NSInteger)numYears {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:1];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:numYears];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)monthIndexDay:(NSInteger)index{

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = [self year];
    dateComponents.month = [self month];;
    dateComponents.day = index;
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];

    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
}

+ (NSString *)currentTimeMillis {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    long long currentTimeMillis = currentTime * 1000;
    return [NSString stringWithFormat:@"%lld", currentTimeMillis];
}

@end
