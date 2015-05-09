//
//  RunCompleteCardsVC.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningRecordEntity.h"

@interface RunCompleteCardsVC : UIViewController

/**
 *  带参数的初始化卡片
 *
 *  @param parameters 参数不能为空
 *
 *  @return 
 */
- (instancetype)initWithParameters:(RunningRecordEntity *)parameters WithPoints:(NSArray *)pints WithImages:(NSArray *)images;


@end
