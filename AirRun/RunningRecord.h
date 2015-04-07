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

@property (nonatomic, strong) NSString  *path;
@property (nonatomic, strong) NSNumber  *time;
@property (nonatomic, strong) NSNumber  *kcar;
@property (nonatomic, strong) NSNumber  *distance;
@property (nonatomic, strong) NSString  *weather;
@property (nonatomic, strong) NSNumber  *pm25;
@property (nonatomic, strong) NSNumber  *averagespeed;
@property (nonatomic, strong) NSString  *finishtime;
@property (nonatomic, strong) AVFile    *mapshot;
@property (nonatomic, strong) NSString  *heart;

- (void)saveWithImages:(NSArray *)images;


@end
