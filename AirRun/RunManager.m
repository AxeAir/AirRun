//
//  RunManager.m
//  AirRun
//
//  Created by JasonWu on 4/11/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunManager.h"
#import <MapKit/MapKit.h>
#import "RunningRecordEntity.h"
#import "RunningImageEntity.h"

@implementation RunManager

#pragma mark - Set Method

- (void)setSpeed:(CGFloat)speed {
    [self willChangeValueForKey:@"speed"];
    _speed = speed;
    [self didChangeValueForKey:@"speed"];
}

- (void)setTime:(NSInteger)time {
    
    [self willChangeValueForKey:@"time"];
    _time = time;
    [self didChangeValueForKey:@"time"];
    
}

- (void)setKcal:(CGFloat)kcal {
    
    [self willChangeValueForKey:@"kcal"];
    _kcal = kcal;
    [self didChangeValueForKey:@"kcal"];
}

- (void)setDistance:(CGFloat)distance {
    
    [self willChangeValueForKey:@"distance"];
    _distance = distance;
    [self didChangeValueForKey:@"distance"];
    
}

#pragma mark - Init

+ (RunManager *)shareInstance {
    
    static RunManager *singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[RunManager alloc] init];
    });
    return singleInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _runState = RunStateStop;
        
        _distance = 0;
        _time = 0;
        _speed = 0;
        _currentSpeed = 0;
        _kcal = 0;
        
        _currentLocationName = @"";
        _temperature = @"";
        _pm = @"";
        
        _points = [[NSMutableArray alloc] init];
        _imageArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

#pragma mark - Action 
#pragma mark Public

- (RunningRecordEntity *)generateRecordEntity {
    
    RunningRecordEntity *record = [[RunningRecordEntity alloc] init];
    [record generateIdentifer];
    record.path = [self p_convertPointsToJsonString];
    record.time = @(_time);
    record.kcar = @(_kcal);
    record.distance = @(_distance);
    record.city = _currentLocationName;
    record.weather = _temperature;
    record.pm25 = @([_pm integerValue]);
    record.averagespeed = @(_speed);
    record.finishtime = [NSDate date];
    
    for (RunningImageEntity *imgEntity in _imageArray) {
        imgEntity.recordid = record.identifer;
    }
    
    return record;
}

#pragma mark Private

- (NSString *)p_convertPointsToJsonString {
    
    NSMutableArray *pointDicArray = [[NSMutableArray alloc] init];
    for (CLLocation *location in self.points) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        
        //键:值
        NSDictionary *pointDic = @{@"latitude":[NSNumber numberWithDouble:location.coordinate.latitude],
                                   @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude],
                                   @"altitude":[NSNumber numberWithDouble:location.altitude],
                                   @"hAccuracy":[NSNumber numberWithDouble:location.horizontalAccuracy],
                                   @"vAccuracy":[NSNumber numberWithDouble:location.verticalAccuracy],
                                   @"course":[NSNumber numberWithDouble:location.course],
                                   @"speed":[NSNumber numberWithDouble:location.speed],
                                   @"timestamp":[dateFormatter stringFromDate:location.timestamp]
                                   };
        [pointDicArray addObject:pointDic];
        
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pointDicArray options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
