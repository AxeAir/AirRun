//
//  RunningRecordEntity.h
//  AirRun
//
//  Created by ChenHao on 4/7/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData+MagicalRecord.h>

@interface RunningRecordEntity : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * kcar;

@end
