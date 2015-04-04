//
//  WeatherModel.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface WeatherModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *weatherFa;
@property (nonatomic, strong) NSString *weatherFb;
@property (nonatomic, strong) NSString *wind;
@property (nonatomic, strong) NSString *dressingIndex;
@property (nonatomic, strong) NSString *dressingAdvice;
@property (nonatomic, strong) NSString *uvIndex;

@property (nonatomic, strong) NSString *washIndex;
@property (nonatomic, strong) NSString *travelIndex;
@property (nonatomic, strong) NSString *exerciseIndex;

@end

//"result": {
//    "today": {
//        "city": "天津",
//        "date_y": "2014年03月21日",
//        "week": "星期五",
//        "temperature": "8℃~20℃",	/*今日温度*/
//        "weather": "晴转霾",	/*今日天气*/
//        "weather_id": {	/*天气唯一标识*/
//            "fa": "00",	/*天气标识00：晴*/
//            "fb": "53"	/*天气标识53：霾 如果fa不等于fb，说明是组合天气*/
//        },
//        "wind": "西南风微风",
//        "dressing_index": "较冷", /*穿衣指数*/
//        "dressing_advice": "建议着大衣、呢外套加毛衣、卫衣等服装。",	/*穿衣建议*/
//        "uv_index": "中等",	/*紫外线强度*/
//        "comfort_index": "",
//        "wash_index": "较适宜",	/*洗车指数*/
//        "travel_index": "适宜",	/*旅游指数*/
//        "exercise_index": "较适宜",	/*晨练指数*/
//        "drying_index": ""
//    },