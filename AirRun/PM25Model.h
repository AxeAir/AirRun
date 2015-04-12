//
//  PM25.h
//  AirRun
//
//  Created by ChenHao on 4/2/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface PM25Model : MTLModel<MTLJSONSerializing>


@property (nonatomic, strong) NSArray *cityName;
@property (nonatomic, strong) NSArray *PM25;
@property (nonatomic, strong) NSArray *AQI;
@property (nonatomic, strong) NSArray *quality;
@property (nonatomic, strong) NSArray *CO;
@property (nonatomic, strong) NSArray *NO2;




@end
