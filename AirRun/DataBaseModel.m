//
//  DataBaseModel.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "DataBaseModel.h"

@implementation DataBaseModel


- (BOOL)save4database
{
    DataBaseHelper *dbHelper = [[DataBaseHelper alloc] init];
    return [dbHelper save4database:self];
}

+ (NSArray *)SelectAll2Array
{
    DataBaseHelper *dbHelper = [[DataBaseHelper alloc] init];
    
    NSString *cn = [NSString stringWithFormat:@"%@",[self class]];
    cn= [cn stringByReplacingOccurrencesOfString:@"Model" withString:@""];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where 1",cn];
    return [dbHelper selectCustomSql:sql classname:self];
}

@end
