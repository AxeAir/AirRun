//
//  RunningRecord.m
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningRecord.h"

@implementation RunningRecord

- (void)saveWithImages:(NSArray *)images heartImages:(NSArray *)heartImages
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
        
        
        NSMutableArray *heartFiles = [[NSMutableArray alloc] init];
        for (UIImage *image in heartImages) {
            NSData *imageData = UIImagePNGRepresentation(image);
            AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
            
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [heartFiles addObject:[imageFile objectId]];
            } progressBlock:^(NSInteger percentDone) {
                
            }];
            
            
            
        }
        [self addObjectsFromArray:heartFiles forKey:@"heartImages"];
        [self save];
    }
}


+ (NSString *)parseClassName {
    return @"RunningRecord";
}


@end
