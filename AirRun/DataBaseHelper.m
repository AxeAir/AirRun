//
//  DataBaseHelper.m
//  SportManV2
//
//  Created by ChenHao on 3/3/15.
//  Copyright (c) 2015 JasonWu. All rights reserved.
//

#import "DataBaseHelper.h"
//
//@interface DataBaseHelper()
//
//@property (nonatomic, strong) FMDatabase *db;
//
//@end
//
//@implementation DataBaseHelper
//
//
//
//- (void)initDB
//{
//    [self CreateDatabase];
//    [self initTable];
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self CreateDatabase];
//    }
//    return self;
//}
//
//- (void )CreateDatabase
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"sportman.sqlite"];
//    //NSLog(@"%@",dbPath);
//    _db = [FMDatabase databaseWithPath:dbPath];
//    [_db open];
//}
//
//
//- (void)initTable
//{
//    
//    if(![_db tableExists:@"FreeTraining"])
//    {
//        [_db executeUpdate:@"CREATE TABLE FreeTraining (mID TEXT PRIMARY KEY, mPic TEXT, usecount INTEGER, subcount INTEGER, isNew INTEGER, timestamp INTEGER, name TEXT, cal TEXT, level INTEGER,SubProjects TEXT)"];
//            NSLog(@"FreeTraining 创建完成");
//    }
//    
//    if(![_db tableExists:@"CourseRecord"])
//    {
//        [_db executeUpdate:@"CREATE TABLE CourseRecord (\
//         CourseID TEXT PRIMARY KEY,\
//         CourseTypeID TEXT,\
//         CourseName TEXT, \
//         CoursePic TEXT, \
//         CourseDesc TEXT, \
//         CoursePriceOrigin TEXT, \
//         CoursePriceNow TEXT, \
//         CourseNumber INTEGER, \
//         Weeks INTEGER,\
//         SubPlan TEXT, \
//         Nowday INTEGER, \
//         Nowweek INTEGER, \
//         UserUUID TEXT, \
//         Dele INTEGER, \
//         Dirty INTEGER, \
//         Finish INTEGER, \
//         StartTime TXT ,\
//         FinishTime TEXT, \
//         Timestamp TEXT)"];
//        NSLog(@"CourseRecord 创建完成");
//    }
//    
//    if(![_db tableExists:@"CoursePlan"])
//    {
//        [_db executeUpdate:@"CREATE TABLE CoursePlan (\
//         CoursePlanID TEXT PRIMARY KEY, \
//         Day1 TEXT,\
//         Day2 TEXT,\
//         Day3 TEXT,\
//         Day4 TEXT,\
//         Day5 TEXT,\
//         PlanName TEXT,\
//         Days INTEGER, \
//         DaysTime INTEGER)"];
//        NSLog(@"CoursePlan 创建完成");
//    }
//    
//    if(![_db tableExists:@"CourseType"])
//    {
//        [_db executeUpdate:@"CREATE TABLE CourseType (\
//         CourseTypeID TEXT PRIMARY KEY,\
//         CourseTypeName TEXT, \
//         CourseTypePic TEXT,\
//         CourseTypeDesc TEXT,\
//         CourseTypePriceOrigin TEXT,\
//         CourseTypePriceNow TEXT,\
//         CoureTypeNumber INTEGER, \
//         Weeks INTEGER,\
//         SubPlan TEXT)"];
//        NSLog(@"CourseType 创建完成");
//    }
//
//    
//    if(![_db tableExists:@"FitProject"])
//    {
//        [_db executeUpdate:@"CREATE TABLE FitProject (\
//         ProjectID TEXT PRIMARY KEY, \
//         ProjectName TEXT, \
//         Area TEXT,\
//         ProjectDesc TEXT,\
//         ProjectPic TEXT, \
//         SmallPic TEXT, \
//         ProjectMovie1 TEXT,\
//         ProjectMovie2 TEXT,\
//         ProjectMovie3 TEXT,\
//         Kcal1 TEXT,\
//         Kcal2 TEXT,\
//         Kcal3 TEXT,\
//         ProjectTime1 TEXT,\
//         ProjectTime2 TEXT,\
//         ProjectTime3 TEXT,\
//         TimesPerGroup1 TEXT , \
//         TimesPerGroup2 TEXT , \
//         TimesPerGroup3 TEXT , \
//         Isnew TEXT,\
//         Level TEXT,\
//         ActNumber INTEGER,\
//         OfficeAllow INTEGER)"];
//        NSLog(@"FitProject 创建完成");
//    }
//    
//    
//    if(![_db tableExists:@"FitProjectRecord"])
//    {
//        [_db executeUpdate:@"CREATE TABLE FitProjectRecord (\
//         uID TEXT PRIMARY KEY,\
//         ProjectID TEXT , \
//         ProjectName TEXT, \
//         Area TEXT,\
//         ProjectDesc TEXT,\
//         ProjectPic TEXT, \
//         SmallPic TEXT, \
//         ProjectMovie TEXT,\
//         Kcal TEXT,\
//         ProjectTime TEXT,\
//         Level TEXT,\
//         IsPublic INTEGER,\
//         Note TEXT,\
//         FinishTime TEXT,\
//         UserUUID TEXT,\
//         Dele INTEGER,\
//         Dirty INTEGER,\
//         TimeStamp TEXT,\
//         TimesPerGroup TEXT)"];
//        NSLog(@"FitProjectRecord 创建完成");
//    }
//    
//    
//    if(![_db tableExists:@"DoingCourse"])
//    {
//        [_db executeUpdate:@"CREATE TABLE DoingCourse (\
//         uID TEXT PRIMARY KEY,\
//         CourseID TEXT ,\
//         ProjectID TEXT , \
//         ProjectName TEXT, \
//         Area TEXT,\
//         ProjectDesc TEXT,\
//         ProjectPic TEXT, \
//         SmallPic TEXT, \
//         ProjectMovie TEXT,\
//         Kcal TEXT,\
//         ProjectTime TEXT,\
//         Level TEXT,\
//         FinishTime TEXT,\
//         UserUUID TEXT,\
//         IsPublic INTEGER,\
//         Note TEXT,\
//         Week INTEGER,\
//         Times INTEGER,\
//         TimesPerGroup TEXT,\
//         Dele INTEGER,\
//         Dirty INTEGER,\
//         TimeStamp TEXT,\
//         RestTime INTEGER)"];
//        NSLog(@"DoingCourse 创建完成");
//    }
//}
//
//- (void)save4database:(id)object
//{
//    // Create the INSERT statement
//    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:object];
//    // Get the values of the record in a format we can use with FMDB
//    NSArray *params = [MTLFMDBAdapter columnValues:object];
//    // Execute our INSERT
//    [_db executeUpdate:stmt withArgumentsInArray:params];
//}
//
//
//- (BOOL)update4database:(id)object
//{
//    NSString *stmt = [MTLFMDBAdapter updateStatementForModel:object];
//    NSArray *params = [MTLFMDBAdapter columnValues:object];
//    return [_db executeUpdate:stmt withArgumentsInArray:params];
//}
//
//- (id)selectCustomSql:(NSString *)sql classname:(id)classname
//{
//    NSError *error = nil;
//    FMResultSet *resultSet = [_db executeQuery:sql];
//    NSMutableArray * result = [[NSMutableArray alloc] init];
//    while ([resultSet next]) {
//        [result addObject:[MTLFMDBAdapter modelOfClass:[classname class] fromFMResultSet:resultSet error:&error]];
//    }
//    [resultSet close];
//    return result;
//}
//
//
//- (id)fetchOne:(NSString *)key value:(NSString *)value table:(NSString *)table class:(id)classname
//{
//    NSError *error = nil;
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",table,key,value];
//    FMResultSet *resultSet = [_db executeQuery:sql];
//    id result;
//    if ([resultSet next]) {
//       result = [MTLFMDBAdapter modelOfClass:[classname class] fromFMResultSet:resultSet error:&error];
//    }
//    [resultSet close];
//    return result;
//}
//
//
//- (BOOL)executeSQL:(NSString *)sql
//{
//    return [_db executeUpdate:sql];
//}
//
//+ (NSString *)GenerateUUID
//{
//    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
//    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
//    CFRelease(uuidRef);
//    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
//    return uniqueId;
//}
//@end
