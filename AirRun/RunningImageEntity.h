//
//  RunningImageEntity.h
//  AirRun
//
//  Created by ChenHao on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BlockMacro.h"
#import <CoreData+MagicalRecord.h>
#import "AirLocalPersistence.h"

@interface RunningImageEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * isheart;
@property (nonatomic, retain) NSString * recordid;

- (instancetype)init;

- (void)savewithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)deleteEntity;
@end
