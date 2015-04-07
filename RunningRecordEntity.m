//
//  RunningRecordEntity.m
//  AirRun
//
//  Created by ChenHao on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningRecordEntity.h"


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
@dynamic objectId;
@dynamic identifer;
@dynamic heartimages;

- (instancetype)init
{
    return [RunningRecordEntity MR_createEntity];
}

- (void)generateIdentifer
{
    NSInteger timestamp = (long)[[NSDate alloc] timeIntervalSince1970];
    self.identifer = [NSString stringWithFormat:@"%@%ld",[[AVUser currentUser] objectId],timestamp];
}


- (void)setImages:(NSArray *)images
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:images];
    self.heartimages = data;
}

- (NSArray *)getImages
{
    if (self.heartimages!=nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:self.heartimages];
    }
    return nil;
}

- (void)savewithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[AirLocalPersistence shareLocalPersistenceInstance] createObject:self withCompleteBlock:^{
        completeBlock();
    } withErrorBlock:^{
        errorBlock();
    }];
}

@end
