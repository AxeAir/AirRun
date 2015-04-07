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

- (void)findObject:(NSManagedObject *)object WithCompleteBlocks:(FetchCompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    NSArray *objects = [[object class] MR_findAll];
    completeBlock(objects);
}


@end
