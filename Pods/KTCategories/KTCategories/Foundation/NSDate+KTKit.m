//
//  NSDate+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "NSDate+KTKit.h"

@implementation NSDate (KTKit)

- (NSInteger)year
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds
{
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
{
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingWeekdays:(NSInteger)weekdays
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekday:weekdays];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.locale = [NSLocale currentLocale];
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:dateString];
}

@end
