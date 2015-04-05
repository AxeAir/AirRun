//
//  DataBaseHelper.m
//  SportManV2
//
//  Created by ChenHao on 3/3/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import "DataBaseHelper.h"
#import <FMDB.h>

@interface DataBaseHelper()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DataBaseHelper



- (void)initDB
{
    [self CreateDatabase];
    [self initTable];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self CreateDatabase];
    }
    return self;
}

- (void )CreateDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"airrun.sqlite"];
    NSLog(@"%@",dbPath);
    _db = [FMDatabase databaseWithPath:dbPath];
    [_db open];
}


- (void)initTable
{
    if(![_db tableExists:@"RunningRecord"])
    {
        [_db executeUpdate:@"CREATE TABLE RunningRecord (\
         UUID TEXT PRIMARY KEY,\
         path TEXT,\
         time INTEGER, \
         kcar INTEGER, \
         weather TEXT, \
         pm25 FLOAT, \
         distance INTEGER,\
         averagespeed FLOAT, \
         finishtime INTEGER,\
         userUUID TEXT, \
         dele INTEGER, \
         dirty INTEGER, \
         timestamp TEXT)"];
        NSLog(@"RunningRecord 创建完成");
    }
    
    if(![_db tableExists:@"RunningImge"])
    {
        [_db executeUpdate:@"CREATE TABLE RunningImge (\
         UUID TEXT PRIMARY KEY,\
         userUUID TEXT,\
         imagename INTEGER, \
         remoteURL INTEGER, \
         latitude INTEGER, \
         longitude TEXT, \
         recordUUID FLOAT)"];
        NSLog(@"RunningImge 创建完成");
    }
    

}

- (BOOL)save4database:(id)object
{
    // Create the INSERT statement
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:object];
    // Get the values of the record in a format we can use with FMDB
    NSArray *params = [MTLFMDBAdapter columnValues:object];
    // Execute our INSERT
    return [_db executeUpdate:stmt withArgumentsInArray:params];
}


- (BOOL)update4database:(id)object
{
    NSString *stmt = [MTLFMDBAdapter updateStatementForModel:object];
    NSArray *params = [MTLFMDBAdapter columnValues:object];
    return [_db executeUpdate:stmt withArgumentsInArray:params];
}

- (id)selectCustomSql:(NSString *)sql classname:(id)classname
{
    NSError *error = nil;
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        [result addObject:[MTLFMDBAdapter modelOfClass:[classname class] fromFMResultSet:resultSet error:&error]];
    }
    [resultSet close];
    return result;
}


- (id)fetchOne:(NSString *)key value:(NSString *)value table:(NSString *)table class:(id)classname
{
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",table,key,value];
    FMResultSet *resultSet = [_db executeQuery:sql];
    id result;
    if ([resultSet next]) {
       result = [MTLFMDBAdapter modelOfClass:[classname class] fromFMResultSet:resultSet error:&error];
    }
    [resultSet close];
    return result;
}


- (BOOL)executeSQL:(NSString *)sql
{
    return [_db executeUpdate:sql];
}

+ (NSString *)GenerateUUID
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}
@end
