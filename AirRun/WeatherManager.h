//
//  WeatherManager.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "WeatherModel.h"
#import "PM25Model.h"
#import <Mantle.h>
#import <TMCache.h>


@interface WeatherManager : NSObject



/**
 *  通过城市名称获得PM2.5
 *
 *  @param cityname 城市名称
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)getPM25WithCityName:(NSString *)cityname success:(void (^)(PM25Model * pm25))success failure:(void (^)(NSError *error))failure;


/**
 *  通过经纬度获得天气
 *
 *  @param longitude 经度
 *  @param latitude  维度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)getWeatherWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude success:(void (^)(WeatherModel * responseObject))success failure:(void (^)(NSError *error))failure;


/**
 *  通过IP获得天气
 *
 *  @param longitude 经度
 *  @param latitude  维度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)getWeatherWithIPAddress:(NSString *)ip success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSError *error))failure;


@end
