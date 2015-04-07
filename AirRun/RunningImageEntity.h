//
//  RunningImageEntity.h
//  Pods
//
//  Created by ChenHao on 4/7/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RunningImageEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSData * image;

@end
