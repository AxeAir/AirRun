//
//  RunningImgeModel.m
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningImgeModel.h"

@implementation RunningImgeModel

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
    return @"RunningImge";
}

- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}
@end
