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
             @"cityName":@"result[0].city",
             @"PM25":@"result[0].PM25",
             @"AQI":@"result[0].AQI",
             @"quality":@"result[0].quality",
             @"CO":@"result[0].CO",
             @"NO2":@"result[0].NO2",
             
             };
}

@end
