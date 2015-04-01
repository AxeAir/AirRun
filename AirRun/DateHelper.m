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

@end
