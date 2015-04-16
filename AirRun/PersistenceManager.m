//
//  PersistenceManager.m
//  AirRun
//
//  Created by ChenHao on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PersistenceManager.h"
#import "DocumentHelper.h"

@interface PersistenceManager()

@property (nonatomic, copy) syncComplete block;

@end

@implementation PersistenceManager

+ (instancetype)shareManager
{
    static PersistenceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PersistenceManager alloc] init];
    });
    return manager;
}


- (void)sync
{
    [self dowaloadRecordwithBlock:^(BOOL successed) {
        [self dowaloadImagewithBlock:^(BOOL successed) {
            [self uploadRecordwithBlock:^(BOOL successed) {
                [self uploadImagewithBlock:^(BOOL successed) {
                }];
            }];
        }];
    }];
}


- (void)syncWithComplete:(syncComplete)completeBlock
{
    _block = completeBlock;
    [self dowaloadRecordwithBlock:^(BOOL successed) {
        [self dowaloadImagewithBlock:^(BOOL successed) {
            [self uploadRecordwithBlock:^(BOOL successed) {
                [self uploadImagewithBlock:^(BOOL successed) {
                    _block(YES);
                }];
            }];
        }];
    }];
}


- (void)dowaloadRecordwithBlock:(void (^)(BOOL successed))result
{
    AVQuery *query = [RunningRecord query];
    [query whereKey:@"userID" equalTo:[[AVUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //下载失败
        if (error) {
            result(NO);
        }
        [[AirLocalPersistence shareLocalPersistenceInstance] PersistenceRecordsFromServerToLocal:objects withCompleteBlock:^{
            result(YES);
        } withErrorBlock:^{
            result(NO);
        }];
        
    }];
    
    
}


- (void)dowaloadImagewithBlock:(void (^)(BOOL successed))result
{
    AVQuery *query = [RunningImage query];
    [query whereKey:@"userID" equalTo:[[AVUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            result(NO);
        }
        [[AirLocalPersistence shareLocalPersistenceInstance] PersistenceImagesFromServerToLocal:objects withCompleteBlock:^{
            result(YES);
        } withErrorBlock:^{
            result(NO);
        }];
    }];
    
    
}

- (void)uploadRecordwithBlock:(void (^)(BOOL successed))result
{
    NSArray *dirtyRecord = [[AirLocalPersistence shareLocalPersistenceInstance] findDirtyRecord];
    //找到所有的待更新数据
    
    for (RunningRecordEntity *record in dirtyRecord) {
        
        //如果是本地未上传的数据
        if (record.objectId ==nil) {
            RunningRecord *newrecord = [RunningRecord object];
            
            newrecord.path = record.path;
            newrecord.time = record.time;//跑步时间  整型  单位为s
            newrecord.kcar = record.kcar;//卡路里，float类型
            newrecord.distance = record.distance;//距离，整型，单位为米
            newrecord.weather = record.weather;//天气，整型
            newrecord.pm25 = record.pm25;//pm25 整型
            newrecord.averagespeed =record.averagespeed; //平局速度，float
            newrecord.finishtime = record.finishtime;
            newrecord.heart = record.heart;
            newrecord.identifer = record.identifer;
            newrecord.city = record.city;
            
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg",record.identifer];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[DocumentHelper documentsFile:imageName AtFolder:kMapImageFolder]];
            
            AVFile *mapFile = [AVFile fileWithData:UIImageJPEGRepresentation(image, 1)];
            newrecord.mapshot = mapFile;
            
            [newrecord setObject:[[AVUser currentUser] objectId] forKey:@"userID"];
            [newrecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
                if (succeeded) {
                    record.objectId = newrecord.objectId;
                    record.updateat = newrecord.createdAt;
                    record.dirty = @0;
                    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                        if (error) {
                            
                        } else if (success) {
                            NSLog(@"本地上传成功");
                        }
                    }];
                }
            }];
            
        }
        //远端存在本条数据
        else
        {
            AVQuery *query = [RunningRecord query];
            RunningRecord *existrecord = (RunningRecord *)[query getObjectWithId:record.objectId];
            
            //比较最后更新时间
            NSComparisonResult result = [record.updateat compare:existrecord.updatedAt];
            
            if (result == NSOrderedSame) {
                NSLog(@"本地与远端数据一致");
                record.dirty = @0;
            }
            //本地早于远端,采用远端的数据
            else if(result == NSOrderedAscending)
            {
                NSLog(@"ddd");
            }
            //本地晚于远端,采用本地的数据
            else if(result == NSOrderedDescending)
            {
                NSLog(@"ddddd");
            }
        }
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (error) {
                
            } else if (success) {
                NSLog(@"本地数据修改成功");
            }
        }];
        
      
        
    }
    result(YES);
    
    
}


- (void)uploadImagewithBlock:(void (^)(BOOL successed))result
{
    NSArray *imagesRecord = [[AirLocalPersistence shareLocalPersistenceInstance] findDirtyImage];
    //找到所有的待更新数据
    
    
    for (RunningImageEntity *imageEntiy in imagesRecord) {
        
        //如果是本地未上传的数据
        if (imageEntiy.objectId ==nil) {
            RunningImage *newrecord = [RunningImage object];
            
            AVACL *acl = [AVACL ACL];
            [acl setReadAccess:YES forUser:[AVUser currentUser]]; //此处设置的是所有人的可读权限
            [acl setWriteAccess:YES forUser:[AVUser currentUser]]; //而这里设置了文件创建者的写权限
            
            newrecord.identifer = imageEntiy.recordid;
            newrecord.latitude = imageEntiy.latitude;//跑步时间  整型  单位为s
            newrecord.longitude = imageEntiy.longitude;//卡路里，float类型
            newrecord.type = imageEntiy.type;
            
#warning 判断文件是否存在
            
            if ([DocumentHelper checkPathExist:[NSString stringWithFormat:@"%@",[DocumentHelper DocumentPath:imageEntiy.localpath]]]) {
                UIImage *imagefile  = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[DocumentHelper DocumentPath:imageEntiy.localpath]]];
                
                AVFile *avfile = [AVFile fileWithName:imageEntiy.localpath data:UIImagePNGRepresentation(imagefile)];
                
                newrecord.image = avfile;//距离，整型，单位为米
            }
            
            [newrecord setObject:[[AVUser currentUser] objectId] forKey:@"userID"];
            [newrecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    imageEntiy.objectId = newrecord.objectId;
                    imageEntiy.updateat = newrecord.createdAt;
                    imageEntiy.dirty = @0;
                    imageEntiy.type = newrecord.type;
                    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                        if (error) {
                            NSLog(@"%@",error);
                        } else if (success) {
                            NSLog(@"本地上传成功");
                        }
                    }];
                }
                else if (error)
                {
                    NSLog(@"%@",error);
                }
            }];
            
        }
        //远端存在本条数据
        else
        {
            AVQuery *query = [RunningImage query];
            RunningImage *existrecord = (RunningImage *)[query getObjectWithId:imageEntiy.objectId];
            
            //比较最后更新时间
            NSComparisonResult result = [imageEntiy.updateat compare:existrecord.updatedAt];
            
            if (result == NSOrderedSame) {
                NSLog(@"本地与远端数据一致");
                imageEntiy.dirty = @0;
            }
            //本地早于远端,采用远端的数据
            else if(result == NSOrderedAscending)
            {
                NSLog(@"ddd");
            }
            //本地晚于远端,采用本地的数据
            else if(result == NSOrderedDescending)
            {
                NSLog(@"ddddd");
            }
        }
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (error) {
                
            } else if (success) {
                NSLog(@"本地数据修改成功");
            }
        }];
        
        
        
    }
    result(YES);
    
    
}



@end
