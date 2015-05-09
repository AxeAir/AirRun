//
//  PM25.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PM25Model.h"

@implementation PM25Model

#pragma mark Mantle property
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cityName":@"result.city",
             @"PM25":@"result.PM25",
             @"AQI":@"result.AQI",
             @"quality":@"result.quality",
             @"CO":@"result.CO",
             @"NO2":@"result.NO2",
             
             };
}

@end
