//
//  NSDate+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KTKit)

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hour;

- (NSInteger)minute;

- (NSInteger)second;

- (NSInteger)nanosecond;

- (NSInteger)weekday;

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;

- (NSDate *)dateByAddingHours:(NSInteger)hours;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSDate *)dateByAddingWeekdays:(NSInteger)weekdays;

- (NSDate *)dateByAddingMonths:(NSInteger)months;

- (NSDate *)dateByAddingYears:(NSInteger)years;

- (NSString *)stringWithFormat:(NSString *)format;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

@end
