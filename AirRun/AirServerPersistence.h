//
//  AIrServerPersistence.h
//  AirRun
//
//  Created by ChenHao on 4/7/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "BlockMacro.h"

/**
 *  远端持久化模型
 */
@interface AirServerPersistence : NSObject

+ (instancetype)shareServerPersistenceInstance;



- (void)createObject:(AVObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;


@end
