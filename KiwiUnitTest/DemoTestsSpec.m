//
//  DemoTestsSpec.m
//  AirRun
//
//  Created by ChenHao on 3/30/15.
//  Copyright 2015 AEXAIR. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "DemoTestsSpec.m"


SPEC_BEGIN(DemoTestsSpec)

describe(@"given String", ^{
    context(@"when assigned to 'Hellow woerld'", ^{
        NSString *string = @"Hello World";
        
        
        beforeEach(^{
            
        });
        
        
        it(@"should exist", ^{
            [[string shouldNot] beNil];
        });
        
        
        it(@"", ^{
            [[string should] equal:@"Hello World"];
        });
        
    });

});

SPEC_END
