//
//  EditSignViewController.h
//  AirRun
//
//  Created by ChenHao on 4/6/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^editComplete)(NSString *name);
@interface EditSignViewController : UIViewController


- (instancetype)initWithBlock:(editComplete )block sign:(NSString *)sign;

@end
