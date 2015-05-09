//
//  RunningRecord.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "RunningImage.h"

@interface RunningRecord : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString  *identifer;
@property (nonatomic, strong) NSString  *path;
@property (nonatomic, strong) NSNumber  *time;//跑步时间  整型  单位为s
@property (nonatomic, strong) NSNumber  *kcar;//卡路里，float类型
@property (nonatomic, strong) NSNumber  *distance;//距离，整型，单位为米
@property (nonatomic, strong) NSString  *weather;//天气，整型
@property (nonatomic, strong) NSNumber  *pm25;//pm25 整型
@property (nonatomic, strong) NSNumber  *averagespeed; //平局速度，float
@property (nonatomic, strong) NSDate    *finishtime;
@property (nonatomic, strong) AVFile    *mapshot;
@property (nonatomic, strong) NSString  *heart;
@property (nonatomic, strong) NSString  *city;
@property (nonatomic, strong) NSNumber  *feel;

@end
