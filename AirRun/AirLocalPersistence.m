//
//  AirLocalPersistence.m
//  AirRun
//
//  Created by ChenHao on 4/7/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "AirLocalPersistence.h"

@implementation AirLocalPersistence

+ (instancetype)shareLocalPersistenceInstance
{
    static dispatch_once_t onceToken;
    static AirLocalPersistence *shareLocalPersistenceInstance;
    dispatch_once(&onceToken, ^{
        shareLocalPersistenceInstance = [[AirLocalPersistence alloc] init];
    });
    return shareLocalPersistenceInstance;
}

- (void)createObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            errorBlock();
        } else if (success) {
            completeBlock();
        }
    }];
}


- (void)deleteObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [object MR_deleteEntity];
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            errorBlock();
        }
        else if(success){
            completeBlock();
        }
    }];
   
}

- (void)updateObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            errorBlock();
        }
        else if(success){
            completeBlock();
        }
    }];
}

- (void)findAllObjects:(Class )cla WithCompleteBlocks:(FetchCompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    NSArray *objects = [cla MR_findAll];
    completeBlock(objects);
}


- (NSArray *)findDirtyRecord
{
    return [RunningRecordEntity MR_findByAttribute:@"dirty" withValue:[NSNumber numberWithInteger:1]];
}

- (NSArray *)findDirtyImage
{
    return [RunningImageEntity MR_findByAttribute:@"dirty" withValue:[NSNumber numberWithInteger:1]];
}

- (id)getObject:(Class)entity withAttribute:(NSString *)attrobute withValue:(id)value
{
    return [entity MR_findFirstByAttribute:attrobute withValue:value];
}

- (void)createRecord:(RunningRecord *)recordOnServer
   withCompleteBlock:(CompleteBlock)completeBlock
      withErrorBlock:(ErrorBlock)errorBlock;
{
    RunningRecordEntity *entity = [RunningRecordEntity MR_createEntity];
    entity.path = recordOnServer.path;
    entity.time = recordOnServer.time;
    entity.kcar = recordOnServer.kcar;
    entity.distance = recordOnServer.distance;
    entity.weather = recordOnServer.weather;
    entity.pm25 = recordOnServer.pm25;
    entity.averagespeed = recordOnServer.averagespeed;
    entity.finishtime = recordOnServer.finishtime;
 
    entity.heart = recordOnServer.heart;
    entity.objectId = recordOnServer.objectId;
    //entity.identifer = recordOnServer.identifer;
    entity.city = recordOnServer.city;
    //entity.heartimages ;
    entity.dirty = @0;
    entity.updateat = recordOnServer.updatedAt;
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            errorBlock();
        } else if (success) {
            completeBlock();
        }
    }];
}


- (void)createImage:(RunningImage *)imageObServer
  withCompleteBlock:(CompleteBlock)completeBlock
     withErrorBlock:(ErrorBlock)errorBlock
{
    RunningImageEntity *entity = [RunningImageEntity MR_createEntity];
    entity.recordid = imageObServer.identifer;
    entity.longitude = imageObServer.longitude;
    entity.latitude = imageObServer.latitude;
    entity.type = imageObServer.type;
    entity.dirty = @0;
    entity.updateat = imageObServer.updatedAt;
    
    AVFile *file = imageObServer.image;
    entity.image = file.url;
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            errorBlock();
        } else if (success) {
            completeBlock();
        }
    }];
}

@end
