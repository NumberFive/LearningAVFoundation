//
//  WXHPlayerController.m
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHPlayerController.h"
#import "WXHTransport.h"
#import "WXHPlayerView.h"
#import "AVAsset+Additions.h"

#define STATUS_KEYPATH @"status"
#define REFRESH_INTERVAL 0.5f

static const NSString *PlayerItemStatusContext;

@interface WXHPlayerController ()<WXHTransportDelegate>
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) WXHPlayerView *playerView;
@property (nonatomic, weak) id <WXHTransport> transport;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) id itemEndObserver;
@property (nonatomic, assign) float lastPlaybackRate;
@end
@implementation WXHPlayerController
- (instancetype)initWithURL:(NSURL *)assetURL
{
    self = [super init];
    if (self) {
        _asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
    }
    return self;
}
- (void)prepareToPlay
{
    NSArray *keys = @[@"tracks",@"duration",@"commonMetadata"];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    
    [self.playerItem addObserver:self
                      forKeyPath:STATUS_KEYPATH
                         options:NSKeyValueObservingOptionNew
                         context:&PlayerItemStatusContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView = [[WXHPlayerView alloc] initWithPlayer:self.player];
    self.transport = self.playerView.transport;
    self.transport.delegate = self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (context == &PlayerItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                
                CMTime duration = self.playerItem.duration;
                [self.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero)
                                      duration:CMTimeGetSeconds(duration)];
                [self.transport setTitle:self.asset.title];
                [self.player play];
            }
        });
    } else {
        NSLog(@"Failed to load video");
    }
}
- (void)addPlayerItemTimeObserver
{
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    __weak WXHPlayerController *weakSelf = self;
    void (^callback)(CMTime time) = ^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.transport setCurrentTime:currentTime duration:duration];
    };
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:callback];
}
- (void)addItemEndObserverForPlayerItem{
    NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    __weak WXHPlayerController *weakSelf = self;
    void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.transport playbackComplete];
        }];
    };
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                                             object:self.playerItem
                                                                              queue:queue
                                                                         usingBlock:callback];
}
- (void)dealloc{
    if (self.itemEndObserver) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.itemEndObserver
                      name:AVPlayerItemDidPlayToEndTimeNotification
                    object:self.playerItem];
        self.itemEndObserver = nil;
    }
}
- (UIView *)view {
    return self.playerView;
}
#pragma mark - WXHTransportDelegate
- (void)play
{
    [self.player play];
}
- (void)pause
{
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}
- (void)stop
{
    [self.player setRate:0.0f];
    [self.transport playbackComplete];
}
- (void)jumpedToTime:(NSTimeInterval)time
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidstart
{
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
}
- (void)scrubbedToTime:(NSTimeInterval)time
{
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}
- (void)scrubbingDidEnd
{
    [self addPlayerItemTimeObserver];
    if (self.lastPlaybackRate > 0.0f) {
        [self.player play];
    }
}
@end
