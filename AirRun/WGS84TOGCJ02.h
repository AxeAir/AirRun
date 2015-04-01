//
//  WGS84TOGCJ02.h
//  AMapTest
//
//  Created by jasonWu on 14/12/4.
//  Copyright (c) 2014年 jasonWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 *  将中国的火星坐标系转化为世界坐标系
 */
@interface WGS84TOGCJ02 : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
