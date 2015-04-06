//
//  RunningRecord.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningRecord.h"

@implementation RunningRecord

- (void)saveWithImages:(NSArray *)images
{
    AVUser *user = [AVUser currentUser];
    if (user) {
        AVACL *acl = [AVACL ACL];
        [acl setReadAccess:YES forUser:[AVUser currentUser]]; //此处设置的是所有人的可读权限
        [acl setWriteAccess:YES forUser:[AVUser currentUser]]; //而这里设置了文件创建者的写权限
        self.ACL = acl;
        [self save];
        
        for (RunningImage *img in images) {
            [img setObject:[AVObject objectWithoutDataWithClassName:@"RunningRecord" objectId:[self objectId]]forKey:@"parent"];
            img.ACL=acl;
            [img saveEventually];
        }
    }
}


+ (NSString *)parseClassName {
    return @"RunningRecord";
}


@end
