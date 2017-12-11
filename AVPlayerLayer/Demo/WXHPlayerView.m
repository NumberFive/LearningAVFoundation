//
//  WXHPlayerView.m
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHPlayerView.h"
#import "WXHOverlayView.h"
@interface WXHPlayerView ()
@property (nonatomic, strong) WXHOverlayView *overlayView;
@end
@implementation WXHPlayerView
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}
- (instancetype)initWithPlayer:(AVPlayer *)player
{
    self = [super initWithFrame:CGRectZero];
    if  (self) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        [self addSubview:self.overlayView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.overlayView.frame = self.bounds;
}
- (id <WXHTransport>)transport
{
    return self.overlayView;
}


@end
