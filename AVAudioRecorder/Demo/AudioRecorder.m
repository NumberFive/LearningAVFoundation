//
//  AudioRecorder.m
//  Demo
//
//  Created by Jerry on 2017/10/29.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "AudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
@interface AudioRecorder ()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, copy) RecordingStopCompletionHandler stopCompletionHandler;
@end
@implementation AudioRecorder
- (instancetype)init
{
    if (self = [super init]) {
        NSString *directory = NSTemporaryDirectory();
        NSLog(@"%@",directory);
        NSString *filePath = [directory stringByAppendingPathComponent:@"voice.caf"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        NSDictionary *settings = @{AVFormatIDKey : @(kAudioFormatAppleIMA4),//音频格式
                                   AVSampleRateKey : @44100.0f,//采样率
                                   AVNumberOfChannelsKey : @1,//通道
                                   AVEncoderBitDepthHintKey : @16,//位元深度
                                   AVEncoderAudioQualityKey : @(AVAudioQualityMedium)//质量
                                   };
        
        NSError *error;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        self.recorder.delegate = self;
        if (self.recorder) {
            [self.recorder prepareToRecord];
        } else {
            NSLog(@"Recorder init Error:%@",[error localizedDescription]);
        }
    }
    return self;
}
- (BOOL)record
{
    self.recording = YES;
    return [self.recorder record];
}
- (void)pause
{
    self.recording = NO;
    [self.recorder pause];
}
- (void)stopWithCompletionHandler:(RecordingStopCompletionHandler)handler
{
    self.recording = NO;
    self.stopCompletionHandler = handler;
    [self.recorder stop];
}
- (void)saveRecordingWithName:(NSString *)name
            CompletionHandler:(RecordingSaveCompletionHandler)handler
{
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *fileName = [NSString stringWithFormat:@"%@-%f.caf",name,timestamp];
    NSString *docsDir = [self documentsDirectory];
    NSString *destPath = [docsDir stringByAppendingPathComponent:fileName];
    
    NSURL *srcURL = self.recorder.url;
    NSURL *destURL = [NSURL fileURLWithPath:destPath];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
    
    if (success) {
        handler(YES,destURL);
    } else {
        handler(NO,error);
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.stopCompletionHandler) {
        self.stopCompletionHandler(flag);
    }
}
#pragma mark - Setter / Getter
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}
- (NSString *)formattedCurrentTime
{
    NSUInteger time = (NSUInteger)self.recorder.currentTime;
    NSInteger hours = time / 3600;
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    
    NSString *format = @"%02i:%02i:%02i";
    return [NSString stringWithFormat:format,hours,minutes,seconds];
}
- (void)setRecording:(BOOL)recording
{
    _recording = recording;
}
@end
