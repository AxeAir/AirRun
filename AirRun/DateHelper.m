//
//  DateHelper.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper


+ (NSString *)getFormatterDate:(NSString *)formatter
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateformatter setDateFormat:formatter];
    return [dateformatter stringFromDate:[NSDate date]];
}

+(NSString *)getDateFormatter:(NSString *)formatter FromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)converSecondsToTimeString:(NSInteger)seconds {
    
    NSInteger tempSeconds = seconds;
    
    NSString *hourStr = @"";
    NSInteger hour = seconds/(60*60);
    tempSeconds %= (60 * 60);
    if (hour > 0) {
        
        if (hour >= 10) {
            hourStr = [NSString stringWithFormat:@"%ld:",(long)hour];
        } else {
            hourStr = [NSString stringWithFormat:@"0%ld:",(long)hour];
        }
        
    }
    
    NSString *minuteStr = @"";
    NSInteger minute = tempSeconds/60;
    tempSeconds %= 60;
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld:",(long)minute];
    } else {
        minuteStr = [NSString stringWithFormat:@"%ld:",(long)minute];
    }
    
    NSString *secondsStr = @"";
    if (tempSeconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%ld",(long)tempSeconds];
    } else {
        secondsStr = [NSString stringWithFormat:@"%ld",(long)tempSeconds];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",hourStr,minuteStr,secondsStr];
}

+ (NSDate *)convertHourandMinuterToDate:(NSString *)time
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    return [dateformatter dateFromString:time];
}

+ (NSString *)convertDateToHourandMinuter:(NSDate *)date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    return [dateformatter stringFromDate:date];
}

@end
