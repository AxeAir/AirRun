//
//  RecordDetailViewController.h
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RunningRecordEntity;
@interface RecordDetailViewController : UIViewController

@property (strong, nonatomic) RunningRecordEntity *record;
@property (weak, nonatomic) IBOutlet UILabel *kcalAppleLabel;

@end
