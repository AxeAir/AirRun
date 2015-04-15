//
//  RunningRecord.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningRecord.h"

@implementation RunningRecord
@dynamic identifer;
@dynamic path;
@dynamic time;//跑步时间  整型
@dynamic kcar;//卡路里，float
@dynamic distance;//距离，整型
@dynamic weather;//天气，整型
@dynamic pm25;//pm25 整型
@dynamic averagespeed; //平局
@dynamic finishtime;
@dynamic mapshot;
@dynamic heart;
@dynamic city;
@dynamic feel;


+ (NSString *)parseClassName {
    return @"RunningRecord";
}


@end
