//
//  ViewController.m
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WXHPlayerController.h"
@interface ViewController ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) WXHPlayerController *playerController;
@end

@implementation ViewController
static const NSString *PlayerItemStatusContext;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];
    
    self.playerController = [[WXHPlayerController alloc] initWithURL:url];
    self.playerController.view.frame = self.view.bounds;
    [self.view addSubview:self.playerController.view];

//    AVAsset *asset = [AVAsset assetWithURL:url];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
//
//    [playerItem addObserver:self
//                 forKeyPath:@"status"
//                    options:0
//                    context:&PlayerItemStatusContext];
//
//    self.player = [AVPlayer playerWithPlayerItem:playerItem];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == &PlayerItemStatusContext) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            playerLayer.frame = self.view.bounds;
            [playerLayer player];
            [self.view.layer addSublayer:playerLayer];
        }
    }
}

@end
