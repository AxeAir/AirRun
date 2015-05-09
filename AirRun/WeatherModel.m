//
//  WeatherModel.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

#pragma mark Mantle property
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"city":@"result.today.city",
             @"temperature":@"result.today.temperature",
             @"weather":@"result.today.weather",
             @"weatherFa":@"result.today.weather_id.fa",
             @"weatherFb":@"result.today.weather_id.fb",
             @"wind":@"result.today.wind",
             @"dressingIndex":@"result.today.dressing_index",
             @"dressingAdvice":@"result.today.dressing_advice",
             @"uvIndex":@"result.today.uv_index",
             @"washIndex":@"result.today.wash_index",
             @"travelIndex":@"result.today.travel_index",
             @"exerciseIndex":@"result.today.exercise_index",
             
             };
}

@end
