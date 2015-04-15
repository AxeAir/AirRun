//
//  DemoTestsSpec.m
//  AirRun
//
//  Created by ChenHao on 3/30/15.
//  Copyright 2015 AEXAIR. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "DemoTestsSpec.m"
#import "WeatherManager.h"


SPEC_BEGIN(DemoTestsSpec)

describe(@"given String", ^{
    context(@"when assigned to 'Hellow woerld'", ^{
        NSString *string = @"Hello World";
        
        __block WeatherManager *manger = nil;
        
        beforeEach(^{
            manger = [WeatherManager shareManager];
        });
        
        
        it(@"should exist", ^{
            
            __block NSString *re = nil;
            
            [manger getRecommandInfoWithLongitude:@29.60 latitude:@106.51 result:^(NSString *recommand) {
                
                re = recommand;
            }];
            
            [[expectFutureValue(re) shouldEventually] beNonNil];
        });
        
        
        it(@"", ^{
            [[string should] equal:@"Hello World"];
        });
        
    });

});

SPEC_END
