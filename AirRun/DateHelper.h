//
//  DateHelper.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
/**
 *  将当前的日期转化成所输入的格式
 *
 *  @param formatter 需要转化成的格式
 *
 *  @return 该格式下的日期的字符串
 */
+ (NSString *)getFormatterDate:(NSString *)formatter;
/**
 *  将指定的日期转化成指定的格式
 *
 *  @param formatter 日期格式
 *  @param date      需要转化的日期
 *
 *  @return 日期转化后的字符串
 */
+ (NSString *)getDateFormatter:(NSString *)formatter FromDate:(NSDate *)date;

/**
 *  将秒数转化成 小时:分钟:秒 格式的字符串
 *
 *  @param seconds 将要转化的秒数
 *
 *  @return 格式化的字符串
 */
+ (NSString *)converSecondsToTimeString:(NSInteger)seconds;

+ (NSDate *)convertHourandMinuterToDate:(NSString *)time;

+ (NSString *)convertDateToHourandMinuter:(NSDate *)date;
@end
