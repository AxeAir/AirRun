//
//  RunningImgeModel.h
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseModel.h"

@interface RunningImgeModel : DataBaseModel<MTLFMDBSerializing>

@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *userUUID;
@property (nonatomic, strong) NSString *imagename;
@property (nonatomic, strong) NSString *remoteURL;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *recordUUID;

@end
