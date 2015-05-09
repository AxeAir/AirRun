//
//  SettingHelper.m
//  AirRun
//
//  Created by ChenHao on 4/18/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SettingHelper.h"

@implementation SettingHelper


+ (BOOL)isOpenVoice
{
    return ![[[AVUser currentUser] objectForKey:@"voiceNotification"] isEqualToString:@"off"];
}
@end
