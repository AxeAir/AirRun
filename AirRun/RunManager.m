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
static  NSString *const kRunMangerKey = @"RunManager";
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

- (void)saveToUserDefault {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *runManagerDic = @{
                                    @"runState":@(_runState),
                                    @"distance":@(_distance),
                                    @"time":@(_time),
                                    @"speed":@(_speed),
                                    @"currentSpeed":@(_currentSpeed),
                                    @"kcal":@(_kcal),
                                    @"currentLocationName":_currentLocationName,
                                    @"temperature":_temperature,
                                    @"pm":_pm,
                                    @"points":[self p_convertPointsToJsonString],
                                    @"imageArray":[self p_convertImageToString]
                                    };
    
    [userDefaults setObject:runManagerDic forKey:kRunMangerKey];
    [userDefaults synchronize];
}

- (void)readFromUserDefault {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *runManagerDic = [userDefaults objectForKey:kRunMangerKey];
    [userDefaults removeObjectForKey:kRunMangerKey];
    [userDefaults synchronize];
    
    _runState = [runManagerDic[@"runState"] integerValue];
    _distance = [runManagerDic[@"distance"] floatValue];
    _time = [runManagerDic[@"time"] integerValue];
    _speed = [runManagerDic[@"speed"] floatValue];
    _currentSpeed = [runManagerDic[@"currentSpeed"] floatValue];
    _kcal = [runManagerDic[@"kcal"] floatValue];
    _currentLocationName = runManagerDic[@"currentLocationName"];
    _temperature = runManagerDic[@"temperature"];
    _pm = runManagerDic[@"pm"];
    _pointsBackUp = [[RunManager convertJsonStringToPath:runManagerDic[@"points"]] mutableCopy];
    _imageArray = [[RunManager convertJsonStringToImages:runManagerDic[@"imageArray"]] mutableCopy];
}

- (void)removeUserDefault {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRunMangerKey];
}

- (BOOL)checkUserDefaultIsAvailable {
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kRunMangerKey];
    if (dic) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)convertJsonStringToImages:(NSString *)json {
    
    NSData *arrayData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:arrayData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in dicArray) {
        RunningImageEntity *imgEntity = [[RunningImageEntity alloc] init];
        imgEntity.latitude = dic[@"latitude"];
        imgEntity.longitude = dic[@"longitude"];
        imgEntity.image = dic[@"image"];
        imgEntity.type = dic[@"type"];
        [imagesArray addObject:imgEntity];
    }
    
    return imagesArray;
}

+ (NSArray *)convertJsonStringToPath:(NSString *)json {
    
    NSData *arrayData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:arrayData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *path = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in dicArray) {
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
        CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coordinate2D
                                                        altitude:[dic[@"altitude"] doubleValue]
                                              horizontalAccuracy:[dic[@"hAccuracy"] doubleValue]
                                                verticalAccuracy:[dic[@"vAccuracy"] doubleValue]
                                                          course:[dic[@"course"] doubleValue]
                                                           speed:[dic[@"speed"] doubleValue]
                                                       timestamp:[formatter dateFromString:dic[@"timestamp"]]];
        [path addObject:loc];
    }
    
    return path;
}


#pragma mark Private

- (NSString *)p_convertImageToString {
    
    NSMutableArray *imgDicArray = [[NSMutableArray alloc] init];
    
    for (RunningImageEntity *imgEntity in _imageArray) {
        NSDictionary *entityDic = @{
                                    @"latitude":imgEntity.latitude,
                                    @"longitude":imgEntity.longitude,
                                    @"image":imgEntity.image,
                                    @"type":imgEntity.type
                                    };
        [imgDicArray addObject:entityDic];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imgDicArray options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)p_convertPointsToJsonString {
    
    NSMutableArray *pointDicArray = [[NSMutableArray alloc] init];
    for (CLLocation *location in self.points) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        
        //键:值
        NSDictionary *pointDic = @{@"latitude":@(location.coordinate.latitude),
                                   @"longitude":@(location.coordinate.longitude),
                                   @"altitude":@(location.altitude),
                                   @"hAccuracy":@(location.horizontalAccuracy),
                                   @"vAccuracy":@(location.verticalAccuracy),
                                   @"course":@(location.course),
                                   @"speed":@(location.speed),
                                   @"timestamp":[dateFormatter stringFromDate:location.timestamp]
                                   };
        [pointDicArray addObject:pointDic];
        
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pointDicArray options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
