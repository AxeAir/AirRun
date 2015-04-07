//
//  NSString+Time.h
//  SportManV2
//
//  Created by ChenHao on 3/8/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (change)

+ (NSString *)DateStringWithDate:(NSDate *)date;

+ (NSDate *)DateWithDateString:(NSString *)strDate;


+ (NSString *)BirthDateStringWithBirthDate:(NSDate *)date;

+ (NSDate *)BirthDateWithBirthDateString:(NSString *)strDate;



+ (NSString *)gettimestamp;
@end
