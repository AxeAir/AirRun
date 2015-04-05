//
//  TimelineTableViewCell.h
//  AirRun
//
//  Created by ChenHao on 4/4/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningRecord.h"

@interface TimelineTableViewCell : UITableViewCell


- (instancetype)initWithRunningRecord:(RunningRecord *)aRunningrecord;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                runningRecord:(RunningRecord *)aRunningrecord;

//- (void)configWithRunningecord:(RunningRecordModel *)aRunningrecord;
@end
