//
//  SpeakHelper.m
//  AirRun
//
//  Created by JasonWu on 4/15/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "SpeakHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface SpeakHelper () <AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;
@property (copy, nonatomic) speakCompleteBlock completeBlock;

@end

@implementation SpeakHelper

#pragma mark - Init

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

#pragma mark - Function
#pragma mark Private

- (void)p_speakString:(NSString *)words {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:words];
    //设置语言类别（不能被识别，返回值为nil）
    AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    //设置语速快慢
    utterance.rate *= 0.1;
    //语音合成器会生成音频
    [self.speechSynthesizer speakUtterance:utterance];
}

#pragma mark Public

- (void)speakString:(NSString *)words {
    
    _speechSynthesizer.delegate = nil;
    _completeBlock = nil;
    [self p_speakString:words];
    
}

- (void)speakString:(NSString *)words WithCompleteBlock:(speakCompleteBlock) completeBlock {
    _completeBlock = completeBlock;
    _speechSynthesizer.delegate = self;
    [self p_speakString:words];
}

#pragma mark - Delegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    if (_completeBlock) {
        _completeBlock (synthesizer,utterance);
    }
    
}

@end
