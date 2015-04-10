//
//  AIrServerPersistence.m
//  AirRun
//
//  Created by ChenHao on 4/7/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AirServerPersistence.h"

@implementation AirServerPersistence

+ (instancetype)shareServerPersistenceInstance
{
    static dispatch_once_t oncenToken;
    static AirServerPersistence *shareServerPersistenceInstance;
    
    dispatch_once(&oncenToken, ^{
        shareServerPersistenceInstance = [[AirServerPersistence alloc] init];
    });
    return shareServerPersistenceInstance;
}


- (void)createObject:(AVObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            errorBlock();
        }
        else if (succeeded)
        {
            completeBlock();
        }
    }];
}



@end
