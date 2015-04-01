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
            __block NSDictionary *fetchedData = nil;
            
            [manager getPM25WithCityName:@"chonqing" success:^(NSDictionary *responseObject) {
                fetchedData = [responseObject objectForKey:@"result"];
            } failure:^(NSError *error) {
                
            }];
            
            [[expectFutureValue(fetchedData) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
        });
    });

});

SPEC_END
