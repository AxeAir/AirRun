//
//  AirLocalPersistence.h
//  AirRun
//
//  Created by ChenHao on 4/7/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData+MagicalRecord.h>
#import "BlockMacro.h"
#import "RunningRecordEntity.h"
#import "RunningRecord.h"
#import "RunningImageEntity.h"

/**
 *  本地持久化模型
 */
@interface AirLocalPersistence : NSObject

/**
 *  获得单例对象
 *
 *  @return 单例对象
 */
+ (instancetype)shareLocalPersistenceInstance;

- (void)createObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)deleteObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)updateObject:(NSManagedObject *)object withCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)findAllObjects:(Class )cla WithCompleteBlocks:(FetchCompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

/**
 *  获取待更新数据
 *
 *  @return
 */
- (NSArray *)findDirtyRecord;

- (NSArray *)findDirtyImage;



- (id)getObject:(Class)entity withAttribute:(NSString *)attrobute withValue:(id)value;




#pragma maek Server Persistence

/**
 *  将一条本地不存在记录的数据持久化
 *
 *  @param recordOnServer 一条本地不存在的远程数据
 *  @param completeBlock  成功
 *  @param errorBlock     失败
 */
- (void)createRecord:(RunningRecord *)recordOnServer
   withCompleteBlock:(CompleteBlock)completeBlock
      withErrorBlock:(ErrorBlock)errorBlock;

/**
 *  将网络上的数据持久化到本地
 *
 *  @param records       数组record
 *  @param completeBlock 成功回调
 *  @param errorBlock    失败
 */
- (void)PersistenceRecordsFromServerToLocal:(NSArray *)records
                          withCompleteBlock:(CompleteBlock)completeBlock
                             withErrorBlock:(ErrorBlock)errorBlock;

/**
 *  将一条本地不存在图片记录进行持久化
 *
 *  @param imageObServer 一条本地不存在的远端图片数据
 *  @param completeBlock 成功
 *  @param errorBlock    失败
 */
- (void)createImage:(RunningImage *)imageObServer
  withCompleteBlock:(CompleteBlock)completeBlock
     withErrorBlock:(ErrorBlock)errorBlock;


/**
 *  将网络上的图片数据持久化到本地
 *
 *  @param records       图片记录数组
 *  @param completeBlock 成功回调
 *  @param errorBlock    失败
 */
- (void)PersistenceImagesFromServerToLocal:(NSArray *)images
                          withCompleteBlock:(CompleteBlock)completeBlock
                             withErrorBlock:(ErrorBlock)errorBlock;

@end
