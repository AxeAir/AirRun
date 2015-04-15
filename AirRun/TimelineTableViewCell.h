//
//  TimelineTableViewCell.h
//  AirRun
//
//  Created by ChenHao on 4/4/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningRecordEntity.h"

typedef void (^didMapSelect)(RunningRecordEntity *record);
@protocol TimelineTableViewCellDelegate;

@interface TimelineTableViewCell : UITableViewCell

- (void)config:(RunningRecordEntity *)runningRecord rowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<TimelineTableViewCellDelegate> delegate;

@end


@protocol TimelineTableViewCellDelegate <NSObject>

- (void)TimelineTableViewCellDidSelcct:(RunningRecordEntity *)record Kcal:(NSString *)kcalText;

- (void)TimelineTableViewCellDidSelcctDelete:(RunningRecordEntity *)record rowAtIndexPath:(NSIndexPath *)indexPath;

@end
