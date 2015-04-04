//
//  WeatherTestsSpec.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright 2015 AEXAIR. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "WeatherTestsSpec.m"
#import "WeatherManager.h"



SPEC_BEGIN(WeatherTestsSpec)

describe(@"given city name chongqing", ^{
    context(@"requste server", ^{
        
        __block WeatherManager *manager =nil;
        beforeEach(^{
            manager= [[WeatherManager alloc] init];
        });
        
        afterEach(^{
            manager = nil;
        });
        
        it(@"respose PM2.5", ^{
            __block PM25Model *pm = nil;
            
            [manager getPM25WithCityName:@"chongqing" success:^(PM25Model *pm25) {
                pm = pm25;
            } failure:^(NSError *error) {
                
            }];
            
            [[expectFutureValue(pm.PM25) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
            [[expectFutureValue(pm.cityName) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        });
        
        it(@"respose weather", ^{
            __block WeatherModel *fetchedData = nil;
            
            [manager getWeatherWithLongitude:@106 latitude:@29 success:^(WeatherModel *responseObject) {
                fetchedData = responseObject;
            } failure:^(NSError *error) {
                
            }];
            [[expectFutureValue(fetchedData.city) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
            [[expectFutureValue(fetchedData) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        });
        
        
    });

});


SPEC_END
