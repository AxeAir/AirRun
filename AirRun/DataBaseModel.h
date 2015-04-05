//
//  DataBaseModel.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import "DataBaseHelper.h"

@interface DataBaseModel : MTLModel

/**
 *  保存当前实体到数据库
 */
- (BOOL)save;

/**
 *  查询某张特定的表的所有数据,通用方法
 *
 *  @param tablename 表名
 *
 *  @return 数组
 */
+ (NSArray *)selectAll;
@end
