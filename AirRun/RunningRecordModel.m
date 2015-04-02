//
//  RunningRecord.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningRecordModel.h"

@implementation RunningRecordModel


#pragma mark Mantle property
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{};
}

+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"UUID"];
}

+ (NSString *)FMDBTableName {
    return @"RunningRecord";
}

- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}


@end
