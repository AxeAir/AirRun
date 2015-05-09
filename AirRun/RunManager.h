//
//  RunManager.h
//  AirRun
//
//  Created by JasonWu on 4/11/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RunStateStop,
    RunStateRunning,
    RunStatePause,
} RunState;

@class RunningRecordEntity;
@interface RunManager : NSObject

@property (assign, nonatomic) RunState runState;

@property (assign, nonatomic) CGFloat distance;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) CGFloat currentSpeed;
@property (assign, nonatomic) CGFloat kcal;

@property (strong, nonatomic) NSString *currentLocationName;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *pm;

@property (strong, nonatomic) NSMutableArray *points;//保存点
@property (strong, nonatomic) NSMutableArray *imageArray;//保存imageEntity
@property (strong, nonatomic) NSMutableArray *pointsBackUp;

+ (RunManager *)shareInstance;
- (RunningRecordEntity *)generateRecordEntity;
- (void)saveToUserDefault;
- (void)readFromUserDefault;
- (void)removeUserDefault;
- (void)reback;
- (BOOL)checkUserDefaultIsAvailable;

+ (NSArray *)convertJsonStringToPath:(NSString *)json;
+ (NSArray *)convertJsonStringToImages:(NSString *)json;

@end
