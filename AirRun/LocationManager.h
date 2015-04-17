//
//  LocationManager.h
//  AirRun
//
//  Created by JasonWu on 4/16/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^locationManagerDidUpdateLocationsBlock)(CLLocationManager *manager,NSArray *locations);
@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocationManager *backgroundLocationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (assign, nonatomic) NSInteger lastDistanceTime;

@property (copy, nonatomic) locationManagerDidUpdateLocationsBlock updateBlock;

+ (LocationManager *)shareInstance;
- (NSString *)timeFormatted:(int)totalSeconds;

@end
