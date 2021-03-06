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
@property (nonatomic, retain) NSString * localpath;
@property (nonatomic, retain) NSString * remotepath;
@property (nonatomic, retain) NSNumber * isheart;
@property (nonatomic, retain) NSString * recordid;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) NSDate   * updateat;

- (instancetype)init;

- (void)savewithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;

- (void)deleteEntityFromContext;



+ (NSArray *)getEntitiesWithArrtribut:(NSString *)attribute WithValue:(id)value;

+ (NSArray *)getHeartArrayByIdentifer:(NSString *)identfier;

+ (NSArray *)getPathArrayByIdentifer:(NSString *)identfier;

+ (void)deleteAllwithCompleteBlock:(CompleteBlock)completeBlock withErrorBlock:(ErrorBlock)errorBlock;
@end
