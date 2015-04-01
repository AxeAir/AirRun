//
//  HeaderView.h
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void (^SelectAvatar)();
@interface HeaderView : UIView

- (void)configUserInfo:(UserModel *)user withBloak:(SelectAvatar)block;

@end
