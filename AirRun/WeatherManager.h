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
@interface WeatherManager : NSObject


- (void)getPM25WithCityName:(NSString *)cityname success:(void (^)(NSDictionary * responseObject))success failure:(void (^)(NSError *error))failure;;


@end
