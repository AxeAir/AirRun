//
//  BlockMacro.h
//  AirRun
//
//  Created by ChenHao on 4/8/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleteBlock)(void);
typedef void (^FetchCompleteBlock)(NSArray *arraydata);
typedef void (^ErrorBlock)(void);

@interface BlockMacro : NSObject

@end
