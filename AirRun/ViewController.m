//
//  ViewController.m
//  AirRun
//
//  Created by ChenHao on 3/30/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "ViewController.h"
#import "WeatherManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    [[[WeatherManager alloc] init] getPM25WithCityName:@"chongqing" success:^(NSDictionary *responseObject) {
//       
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
