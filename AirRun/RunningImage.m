//
//  RunningImgeModel.m
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RunningImage.h"

@implementation RunningImage
@dynamic latitude;
@dynamic longitude;
@dynamic image;
@dynamic type;

+ (NSString *)parseClassName {
    return @"RunningImage";
}


@end
