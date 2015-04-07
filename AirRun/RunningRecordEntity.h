//
//  RunningRecordEntity.h
//  Pods
//
//  Created by ChenHao on 4/7/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RunningRecordEntity : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * kcar;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSNumber * pm25;
@property (nonatomic, retain) NSNumber * averagespeed;
@property (nonatomic, retain) NSDate * finishtime;
@property (nonatomic, retain) NSData * mapshot;
@property (nonatomic, retain) NSString * heart;

@end
