//
//  RunningRecordEntity.h
//  AirRun
//
//  Created by ChenHao on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVOSCloud.h>
#import <CoreData+MagicalRecord.h>
#import "AirLocalPersistence.h"
#import "BlockMacro.h"


@interface RunningRecordEntity : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * kcar;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSNumber * pm25;
@property (nonatomic, retain) NSNumber * averagespeed;
@property (nonatomic, retain) NSDate * finishtime;
@property (nonatomic, retain) NSString * mapshot;
@property (nonatomic, retain) NSDate   * finishtime;
@property (nonatomic, retain) NSString * heart;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * identifer;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSData   * heartimages;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) NSDate   * updateat;

- (instancetype)init;

/**
 *  生成标识符
 */
- (void)generateIdentifer;


- (void)setImages:(NSArray *)images;

- (NSArray *)getImages;

- (void)savewithCompleteBlock:(CompleteBlock)completeBlock
               withErrorBlock:(ErrorBlock)errorBlock;

+ (void)findAllWithCompleteBlocks:(FetchCompleteBlock)completeBlock
                   withErrorBlock:(ErrorBlock)errorBlock;
;

@end
