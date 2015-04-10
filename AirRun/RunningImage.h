//
//  RunningImgeModel.h
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

@interface RunningImage : AVObject

@property (nonatomic, strong) NSString *identifer;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) AVFile *image;

@end
