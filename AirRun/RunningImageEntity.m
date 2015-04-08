//
//  RunningImageEntity.m
//  AirRun
//
//  Created by ChenHao on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningImageEntity.h"
#import <CoreData+MagicalRecord.h>


@implementation RunningImageEntity

@dynamic latitude;
@dynamic longitude;
@dynamic image;
@dynamic isheart;
@dynamic recordid;

- (instancetype)init
{
    return [RunningImageEntity MR_createEntity];
}

@end
