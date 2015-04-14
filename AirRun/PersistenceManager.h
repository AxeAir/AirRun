//
//  PersistenceManager.h
//  AirRun
//
//  Created by ChenHao on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "RunningRecord.h"
#import "RunningRecordEntity.h"

typedef void (^syncComplete)(BOOL successed);

@interface PersistenceManager : NSObject

+ (instancetype)shareManager;

- (void)sync;

- (void)syncWithComplete:(syncComplete)completeBlock;


@end
