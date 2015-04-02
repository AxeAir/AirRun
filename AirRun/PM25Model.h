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


@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *PM25;
@property (nonatomic, strong) NSString *AQI;
@property (nonatomic, strong) NSString *quality;
@property (nonatomic, strong) NSString *CO;
@property (nonatomic, strong) NSString *NO2;




@end
