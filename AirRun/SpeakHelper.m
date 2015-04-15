//
//  SpeakHelper.m
//  AirRun
//
//  Created by JasonWu on 4/15/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SpeakHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface SpeakHelper ()

@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation SpeakHelper

+ (SpeakHelper *)shareInstance {
    static  SpeakHelper *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SpeakHelper alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return self;
}

- (void)speakString:(NSString *)words {
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:words];
    //设置语言类别（不能被识别，返回值为nil）
    AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    //设置语速快慢
    utterance.rate *= 0.1;
    //语音合成器会生成音频
    [self.speechSynthesizer speakUtterance:utterance];
    
}

@end
