//
//  DateHelper.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSString *)getFormatterDate:(NSString *)formatter;
+ (NSString *)getDateFormatter:(NSString *)formatter FromDate:(NSDate *)date;

+ (NSString *)converSecondsToTimeString:(NSInteger)seconds;

+ (NSDate *)convertHourandMinuterToDate:(NSString *)time;

+ (NSString *)convertDateToHourandMinuter:(NSDate *)date;
@end