//
//  WeatherManager.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "WeatherManager.h"
#import <TMCache.h>

@interface WeatherManager()


@end

@implementation WeatherManager

+ (instancetype)shareManager
{
    static WeatherManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeatherManager alloc] init];
    });
    return manager;
}


- (void)getPM25WithCityName:(NSString *)cityname success:(void (^)(PM25Model *))success failure:(void (^)(NSError *))failure
{
    
    NSDictionary *weather = [[TMCache sharedCache] objectForKey:@"pm25Cache"];
    if (weather) {
        NSString *timestamp = [weather objectForKey:@"timestamp"];
        NSDate* nowdate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger now = (long)[nowdate timeIntervalSince1970];
        if (now - [timestamp integerValue]<4*3600) {
            NSLog(@"Cache");
            success([weather objectForKey:@"pm25"]);
            return;
        }
    }
    
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:@"JH33e45daec2d71d0d5f9a9c05da34aff9"];
    NSString *path = @"http://web.juhe.cn:8080/environment/air/pm";
    NSString *api_id = @"33";
    NSString *method = @"GET";
    NSDictionary *param = @{@"dtype":@"json",@"city":cityname};
    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
    
    [juheapi executeWorkWithAPI:path
                          APIID:api_id
                     Parameters:param
                         Method:method
                        Success:^(id responseObject){
                            if ([[param objectForKey:@"dtype"] isEqualToString:@"xml"]) {
                                NSLog(@"***xml*** \n %@", responseObject);
                            }else{
                                int error_code = [[responseObject objectForKey:@"error_code"] intValue];
                                if (!error_code) {
                                    
                                    NSDate* nowdate = [NSDate dateWithTimeIntervalSinceNow:0];
                                    NSInteger now = (long)[nowdate timeIntervalSince1970];
                                    
                                    NSDictionary *weather = @{@"timestamp":[NSString stringWithFormat:@"%ld",now],@"pm25":[MTLJSONAdapter modelOfClass:[PM25Model class] fromJSONDictionary:responseObject error:nil]};
                                    
                                    [[TMCache sharedCache] setObject:weather forKey:@"pm25Cache"];
                                    success([MTLJSONAdapter modelOfClass:[PM25Model class] fromJSONDictionary:responseObject error:nil]);
                                }else{
                                    NSLog(@" %@", responseObject);
                                }
                            }
                        } Failure:^(NSError *error) {
                            NSLog(@"error:   %@",error.description);
                            failure(error);
                        }];
}




- (void)getWeatherWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude success:(void (^)(WeatherModel *))success failure:(void (^)(NSError *))failure
{
    
    NSDictionary *weather = [[TMCache sharedCache] objectForKey:@"weatherCache"];
    if (weather) {
        NSString *timestamp = [weather objectForKey:@"timestamp"];
        NSDate* nowdate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger now = (long)[nowdate timeIntervalSince1970];
        if (now - [timestamp integerValue]<4*3600) {
            NSLog(@"Cache");
            success([weather objectForKey:@"weather"]);
            return;
        }
    }
    
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:@"JH33e45daec2d71d0d5f9a9c05da34aff9"];
    NSString *path = @"http://v.juhe.cn/weather/geo";
    NSString *api_id = @"39";
    NSString *method = @"GET";
    NSDictionary *param = @{@"dtype":@"json",@"lon":longitude,@"lat":latitude,@"format":[NSNumber numberWithInt:2]};
    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
    
    [juheapi executeWorkWithAPI:path
                          APIID:api_id
                     Parameters:param
                         Method:method
                        Success:^(id responseObject){
                            if ([[param objectForKey:@"dtype"] isEqualToString:@"xml"]) {
                                NSLog(@"***xml*** \n %@", responseObject);
                            }else{
                                int error_code = [[responseObject objectForKey:@"error_code"] intValue];
                                if (!error_code) {
                                    //[self SetWeatherCache:responseObject];
                                    
                                    NSDate* nowdate = [NSDate dateWithTimeIntervalSinceNow:0];
                                    NSInteger now = (long)[nowdate timeIntervalSince1970];
                                    
                                    NSDictionary *weather = @{@"timestamp":[NSString stringWithFormat:@"%ld",now],@"weather":[MTLJSONAdapter modelOfClass:[WeatherModel class] fromJSONDictionary:responseObject error:nil]};
                                    
                                    [[TMCache sharedCache] setObject:weather forKey:@"weatherCache"];
                                    success([MTLJSONAdapter modelOfClass:[WeatherModel class] fromJSONDictionary:responseObject error:nil]);
                                    
                                }else{
                                    NSLog(@" %@", responseObject);
                                }
                            }
                        } Failure:^(NSError *error) {
                            NSLog(@"error:   %@",error.description);
                            failure(error);
                        }];
    
}


- (void)getWeatherWithIPAddress:(NSString *)ip success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
}

- (void )getRecommandInfoWithLongitude:(NSNumber *)longitude latitude:(NSNumber *)latitude city:(NSString *)cityName result:(void (^)(NSString *recommand))block;
{
    __block WeatherModel *weatherModel =nil;
    __block PM25Model *pm25Model =nil;
    dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        [[WeatherManager shareManager] getWeatherWithLongitude:longitude latitude:latitude success:^(WeatherModel *responseObject) {
            weatherModel = responseObject;
            
        } failure:^(NSError *error) {
            
        }];
    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        [[WeatherManager shareManager] getPM25WithCityName:cityName success:^(PM25Model *pm25) {
            pm25Model = pm25;
        } failure:^(NSError *error) {
            
        }];
    });
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        
        if (weatherModel != nil && pm25Model !=nil) {
            if ([pm25Model.AQI[0] integerValue]>150||[weatherModel.wind integerValue]>4) {
                block(@"不适合");
            }
            
            
        }
        else
        {
            block(nil);
        }
        
    });
}
@end
