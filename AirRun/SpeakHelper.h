//
//  SpeakHelper.h
//  AirRun
//
//  Created by JasonWu on 4/15/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVSpeechSynthesizer;
@class AVSpeechUtterance;

typedef void(^speakCompleteBlock)(AVSpeechSynthesizer *synthesizer,AVSpeechUtterance *utterance);

@interface SpeakHelper : NSObject

+ (SpeakHelper *)shareInstance;

- (void)speakString:(NSString *)words;
- (void)speakString:(NSString *)words WithCompleteBlock:(speakCompleteBlock) completeBlock;

@end
