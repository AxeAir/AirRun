//
//  NSString+Time.m
//  SportManV2
//
//  Created by ChenHao on 3/8/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import "NSDate+change.h"

@implementation NSDate(change)


+ (NSString *)DateStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}


+ (NSDate *)DateWithDateString:(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateTime = [formatter dateFromString:strDate];
    return dateTime;
}


+ (NSString *)BirthDateStringWithBirthDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}


+ (NSDate *)BirthDateWithBirthDateString:(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateTime = [formatter dateFromString:strDate];
    return dateTime;
}


+ (NSString *)gettimestamp
{
    return [NSString stringWithFormat:@"%ld",(long)[[[NSDate alloc] init] timeIntervalSince1970]];
}
@end
