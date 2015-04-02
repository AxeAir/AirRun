//
//  DataBaseHelper.h
//  SportManV2
//
//  Created by ChenHao on 3/3/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseHelper : NSObject

- (void)initDB;

/**
 *  保存实体到数据库
 *
 *  @param object 实体
 */
- (void)save4database:(id)object;

/**
 *  在数据库更新实体
 *
 *  @param object 实体
 *
 *  @return 是否成功更新
 */
- (BOOL)update4database:(id)object;

- (id)fetchOne:(NSString *)key value:(NSString *)value table:(NSString *)table class:(id)classname;

- (id)selectCustomSql:(NSString *)sql classname:(id)classname;

/**
 *  执行非查询语句
 *
 *  @param sql sql语句
 *
 *  @return 是否插入成功
 */
- (BOOL)executeSQL:(NSString *)sql;

/**
 *  生成唯一的UUID
 *
 *  @return UUID
 */
+ (NSString *)GenerateUUID;

@end
