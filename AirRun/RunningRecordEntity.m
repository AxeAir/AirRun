//
//  RunningRecordEntity.m
//  AirRun
//
//  Created by ChenHao on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningRecordEntity.h"
#import "DocumentHelper.h"


@implementation RunningRecordEntity

@dynamic path;
@dynamic time;
@dynamic kcar;
@dynamic distance;
@dynamic weather;
@dynamic pm25;
@dynamic averagespeed;
@dynamic finishtime;
@dynamic mapshot;
@dynamic heart;
@dynamic city;
@dynamic objectId;
@dynamic identifer;
@dynamic updateat;
@dynamic dirty;
@dynamic feel;

- (instancetype)init
{
    return [RunningRecordEntity MR_createEntity];
}

- (void)generateIdentifer
{
    NSInteger timestamp = (long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    self.identifer = [NSString stringWithFormat:@"%@%ld",[[AVUser currentUser] objectId],(long)timestamp];
}


- (void)savewithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[AirLocalPersistence shareLocalPersistenceInstance] createObject:self withCompleteBlock:^{
        completeBlock();
    } withErrorBlock:^{
        errorBlock();
    }];
}

+ (void)findAllWithCompleteBlocks:(FetchCompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[AirLocalPersistence shareLocalPersistenceInstance] findAllObjects:[RunningRecordEntity class] WithCompleteBlocks:^(NSArray *arraydata) {
        completeBlock(arraydata);
    } withErrorBlock:^{
        errorBlock();
    }];
}

- (void)deleteEntity
{
    NSString *objectId = self.objectId;
    
    AVQuery *query = [RunningRecord query];
    [query getObjectInBackgroundWithId:objectId block:^(AVObject *object, NSError *error) {
        
        //远端不存在该数据
        if ([object objectId] == nil) {
            [[AirLocalPersistence shareLocalPersistenceInstance] deleteObject:self withCompleteBlock:^{
                
            } withErrorBlock:^{
                
            }];
        }
        else
        {
            RunningRecord *record = (RunningRecord *)object;
            AVQuery *query = [RunningImage query];
            [query whereKey:@"identifer" equalTo:record.identifer];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                for (RunningImage *image in objects) {
                    [image deleteEventually];
                }
                
            }];
            [[AirLocalPersistence shareLocalPersistenceInstance] deleteObject:self withCompleteBlock:^{
                
            } withErrorBlock:^{
                
            }];
        }
        
    }];

}

+ (void)deleteAllwithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"RunningRecordEntity" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    [request setEntity:description];
    
    NSArray *datas1 = [RunningRecordEntity MR_executeFetchRequest:request];
    if (datas1 && [datas1 count])
    {
        for (RunningRecordEntity *obj in datas1)
        {
            [obj MR_deleteEntity];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (success) {
                completeBlock();
            }
            if (error) {
                errorBlock();
            }
        }];
    }
    completeBlock();
}


@end
