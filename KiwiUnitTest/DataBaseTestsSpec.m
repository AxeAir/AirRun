//
//  DataBaseTestsSpec.m
//  AirRun
//
//  Created by ChenHao on 4/3/15.
//  Copyright 2015 AEXAIR. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "DataBaseTestsSpec.m"
#import "RunningRecordModel.h"

SPEC_BEGIN(DataBaseTestsSpec)

describe(@"RunningRecord", ^{
    
    __block RunningRecordModel *model = nil;
    
    model = [[RunningRecordModel alloc] init];
    model.UUID = [DataBaseHelper GenerateUUID];
    
    context(@"insert", ^{
        it(@"should return YES", ^{
            BOOL success= [model save4database];
            [[theValue(success) should] beYes];
            
        });
        
        
    });
    
    context(@"select", ^{
        it(@"the array should not be nil", ^{
            NSArray *models =[RunningRecordModel SelectAll2Array];
            [[theValue([models count]) shouldNot] beZero];
        });
        
    });

});

SPEC_END
