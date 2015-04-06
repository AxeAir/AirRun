//
//  EditNickNameViewController.h
//  AirRun
//
//  Created by ChenHao on 4/5/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^editComplete)(NSString *name);

@interface EditNickNameViewController : UIViewController


- (instancetype)initWithBlock:(editComplete )block name:(NSString *)name;

@end
