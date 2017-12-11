//
//  AudioPlayer.m
//  Demo
//
//  Created by Jerry on 2017/10/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
@implementation AudioPlayer
- (instancetype)init
{
    if (self = [super init]) {
        [self addNotifications];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotifications
{
    NSNotificationCenter *notificat = [NSNotificationCenter defaultCenter];
    //注册一个中断的通知，如：电话接入、闹钟等
    [notificat addObserver:self
                  selector:@selector(handleInterruption:)
                      name:AVAudioSessionInterruptionNotification
                    object:nil];
    
    //注册线路改变的通知，如：接上耳机
    [notificat addObserver:self
                  selector:@selector(handleRouteChange:)
                      name:AVAudioSessionRouteChangeNotification
                    object:nil];
}
- (void)handleInterruption:(NSNotification *)notificat
{
    NSDictionary *info = notificat.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self stop];
    } else {
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            [self play];
        }
    }
}
- (void)handleRouteChange:(NSNotification *)notificat
{
    NSDictionary *info = notificat.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = info[AVAudioSessionRouteChangePreviousRouteKey];
        //从线路描述中获取第一个输出接口描述
        AVAudioSessionPortDescription *portDescription = routeDescription.outputs[0];
        
        //判断接口类型是否是耳机接入
        NSString *portType = portDescription.portType;
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self stop];
        }
    }
}
- (void)playWithUrl:(NSURL *)url
{
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (self.audioPlayer) {
        self.audioPlayer.numberOfLoops = -1;
        self.audioPlayer.enableRate = YES;
        [self.audioPlayer prepareToPlay];
    } else {
        NSLog(@"Error creating player: %@", [error localizedDescription]);
    }
    [self play];
}
- (void)play
{
    if (!self.playing && self.audioPlayer) {
        //如果需要多个播放器进行同步，则需要捕捉当前设备时间并添加一个小延时，这样就会具有一个从开始播放时间计算的参考时间
        //这就保证了这些播放器在播放时始终保持紧密同步
        //疑点：当闹钟中断恢复的时候，设备时间会变的很大
//        NSTimeInterval delayTime = [self.audioPlayer deviceCurrentTime] + 0.01;
//        [self.audioPlayer playAtTime:delayTime];
        [self.audioPlayer play];
        
        self.playing = YES;
    }
}
- (void)stop
{
    if (self.playing) {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0.0f;//让播放进度回到原点
        self.playing = NO;
    }
}
- (void)pause
{
    if (self.playing) {
        [self.audioPlayer pause];
        self.playing = NO;
    }
}
- (void)adjustPan:(float)pan
{
    self.audioPlayer.pan = pan;
}
- (void)adjustRate:(float)rate
{
    self.audioPlayer.rate = rate;
}
- (void)adjustVolume:(float)volume
{
    self.audioPlayer.volume = volume;
}

#pragma mark - Setter / Getter
- (void)setPlaying:(BOOL)playing
{
    _playing = playing;
}
@end
