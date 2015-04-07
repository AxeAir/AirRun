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
@end
