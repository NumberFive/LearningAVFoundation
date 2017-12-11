//
//  WXHTransport.h
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXHTransportDelegate <NSObject>
- (void)play;
- (void)pause;
- (void)stop;

- (void)scrubbingDidstart;
- (void)scrubbedToTime:(NSTimeInterval)time;
- (void)scrubbingDidEnd;
- (void)jumpedToTime:(NSTimeInterval)time;
@end

@protocol WXHTransport <NSObject>
@property (nonatomic, weak) id<WXHTransportDelegate> delegate;
- (void)setTitle:(NSString *)time;
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)playbackComplete;
@end
