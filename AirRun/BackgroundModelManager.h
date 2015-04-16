//
//  BackgroundModelManager.h
//  SelfService
//
//  Created by shanezhang on 14-8-19.
//  Copyright (c) 2014年 Beijing ShiShiKe Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundModelManager : NSObject

+ (BackgroundModelManager *)sharedInstance;

/**
 *  开启后台模式
 */
- (void)openBackgroundModel;

/**
 *  关闭后台模式
 */
- (void)closeBackgroundModel;
@end
