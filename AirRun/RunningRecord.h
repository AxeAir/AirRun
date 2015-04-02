//
//  RunningRecord.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseModel.h"

@interface RunningRecord : DataBaseModel


@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger kcar;
@property (nonatomic, assign) NSInteger disntance;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, assign) float pm25;
@property (nonatomic, assign) float averagespeed;

@property (nonatomic, strong) NSString *finishtime;

@end
