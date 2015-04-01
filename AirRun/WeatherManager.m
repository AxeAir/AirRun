//
//  WeatherManager.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "WeatherManager.h"

@implementation WeatherManager


- (void)getPM25WithCityName:(NSString *)cityname success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:@"JH33e45daec2d71d0d5f9a9c05da34aff9"];
    NSString *path = @"http://web.juhe.cn:8080/environment/air/pm";
    NSString *api_id = @"33";
    NSString *method = @"GET";
    NSDictionary *param = @{@"dtype":@"json",@"city":@"重庆"};
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
                                    success(responseObject);
                                    
                                }else{
                                    NSLog(@" %@", responseObject);
                                }
                            }
                        } Failure:^(NSError *error) {
                            NSLog(@"error:   %@",error.description);
                        }];
}

@end
