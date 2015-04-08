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
@dynamic heartimages;

- (instancetype)init
{
    return [RunningRecordEntity MR_createEntity];
}

- (void)generateIdentifer
{
    NSInteger timestamp = (long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    self.identifer = [NSString stringWithFormat:@"%@%ld",[[AVUser currentUser] objectId],timestamp];
}


- (void)setImages:(NSArray *)images
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    NSInteger timestamp = (long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    for (UIImage *image in images) {
        
        NSString *path = [DocumentHelper saveImage:image ToFolderName:@"Image" WithImageName:[NSString stringWithFormat:@"%ld_1_%ld.png",timestamp,index]];
        [temp addObject:path];
        index++;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:temp];
    self.heartimages = data;
}

- (NSArray *)getImages
{
    if (self.heartimages!=nil) {
        [NSKeyedUnarchiver unarchiveObjectWithData:self.heartimages];
        
        NSMutableArray *temp =[[NSMutableArray alloc] init];
        for (NSString *path in [NSKeyedUnarchiver unarchiveObjectWithData:self.heartimages]) {
            
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[DocumentHelper documentsPath],path];
            [temp addObject:[UIImage imageWithContentsOfFile:filePath]];
        }
        return temp;
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

+ (void)findAllWithCompleteBlocks:(FetchCompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock
{
    [[AirLocalPersistence shareLocalPersistenceInstance] findAllObjects:[RunningRecordEntity class] WithCompleteBlocks:^(NSArray *arraydata) {
        completeBlock(arraydata);
    } withErrorBlock:^{
        errorBlock();
    }];
}

@end
