//
//  LocationManager.m
//  AirRun
//
//  Created by JasonWu on 4/16/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@end

@implementation LocationManager

+ (LocationManager *)shareInstance {
    static LocationManager *locationManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        locationManager = [[LocationManager alloc] init];
    });
    return locationManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self p_initLocationManager];
        [self p_initBackgroundLocationManager];
    }
    return self;
}

- (void)p_initLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationManager.distanceFilter = 5.0f;
    _locationManager.activityType = CLActivityTypeOtherNavigation;
    
    //检查是否是ios8 如果是就获得许可
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)p_initBackgroundLocationManager {
    
    _backgroundLocationManager = [[CLLocationManager alloc] init];
    _backgroundLocationManager.delegate = self;
    _backgroundLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _backgroundLocationManager.distanceFilter = 5.0f;
    
    //检查是否是ios8 如果是就获得许可
    if ([_backgroundLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_backgroundLocationManager requestAlwaysAuthorization];
    }
}

#pragma mark - Action

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSString *secondsStr = [NSString stringWithFormat:@"%d秒",seconds];
    NSString *minutesStr = @"";
    if (minutes > 0) {
        minutesStr = [NSString stringWithFormat:@"%d分",minutes];
    }
    NSString *hourStr = @"";
    if (hours>0) {
        hourStr = [NSString stringWithFormat:@"%d小时",hours];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",hourStr, minutesStr, secondsStr];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (_updateBlock) {
        _updateBlock (manager,locations);
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    NSLog(@"error: %@",error.description);
}

@end
