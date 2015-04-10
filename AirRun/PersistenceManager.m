//
//  PersistenceManager.m
//  AirRun
//
//  Created by ChenHao on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "PersistenceManager.h"
#import "DocumentHelper.h"

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
    [self dowaload];
    [self uploadRecord];
    [self uploadImage];
}


- (void)dowaload
{
    AVQuery *query = [AVQuery queryWithClassName:@"RunningRecord"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
        for (RunningRecord *recordOnserver in objects) {
            RunningRecordEntity *localEntity = [[AirLocalPersistence shareLocalPersistenceInstance] getObject: [RunningRecordEntity class]withAttribute:@"objectId" withValue:recordOnserver.objectId];
            
            //如果本地不存在,将服务端的record写入数据库
            if (localEntity == nil) {
                [[AirLocalPersistence shareLocalPersistenceInstance] createRecord:recordOnserver withCompleteBlock:^{
                    
                } withErrorBlock:^{
                    
                }];
            }
            //本地已经存在数据
            else
            {
                
                
            }
            
        }
        
        
        
        
        
    }];
    
    
}

- (void)uploadRecord
{
    NSArray *dirtyRecord = [[AirLocalPersistence shareLocalPersistenceInstance] findDirtyRecord];
    //找到所有的待更新数据
    
    for (RunningRecordEntity *record in dirtyRecord) {
        
        //如果是本地未上传的数据
        if (record.objectId ==nil) {
            RunningRecord *newrecord = [RunningRecord object];
            
            AVACL *acl = [AVACL ACL];
            [acl setReadAccess:YES forUser:[AVUser currentUser]]; //此处设置的是所有人的可读权限
            [acl setWriteAccess:YES forUser:[AVUser currentUser]]; //而这里设置了文件创建者的写权限
            
            newrecord.path = record.path;
            newrecord.time = record.time;//跑步时间  整型  单位为s
            newrecord.kcar = record.kcar;//卡路里，float类型
            newrecord.distance = record.distance;//距离，整型，单位为米
            newrecord.weather = record.weather;//天气，整型
            newrecord.pm25 = record.pm25;//pm25 整型
            newrecord.averagespeed =record.averagespeed; //平局速度，float
            newrecord.finishtime = record.finishtime;
            newrecord.heart = record.heart;
            //newrecord.ACL = acl;
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
    
    
}


- (void)uploadImage
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
            
            UIImage *imagefile  = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[DocumentHelper DocumentPath:imageEntiy.image]]];
            
            AVFile *avfile = [AVFile fileWithName:imageEntiy.image data:UIImagePNGRepresentation(imagefile)];
            
            newrecord.image = avfile;//距离，整型，单位为米
          
            //newrecord.ACL = acl;
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
    
    
}



@end
