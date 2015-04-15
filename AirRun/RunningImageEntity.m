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
@dynamic localpath;
@dynamic remotepath;
@dynamic isheart;
@dynamic recordid;
@dynamic type;
@dynamic dirty;
@dynamic updateat;
@dynamic objectId;

- (instancetype)init
{
    return [RunningImageEntity MR_createEntity];
}


- (void)savewithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[AirLocalPersistence shareLocalPersistenceInstance] createObject:self withCompleteBlock:^{
        if (completeBlock) {
            completeBlock();
        }
    } withErrorBlock:^{
        if (errorBlock) {
            errorBlock();
        }
    }];
}


- (void)deleteEntityFromContext
{
    [self MR_deleteEntity];
}

+ (void)deleteAllwithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"RunningImageEntity" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    [request setEntity:description];
    
    NSArray *datas1 = [RunningImageEntity MR_executeFetchRequest:request];
    if (datas1 && [datas1 count])
    {
        for (RunningImageEntity *obj in datas1)
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


+ (NSArray *)getEntitiesWithArrtribut:(NSString *)attribute WithValue:(id)value {
   return [RunningImageEntity MR_findByAttribute:attribute withValue:value];
}
@end
