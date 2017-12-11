//
//  AudioPlayer.h
//  Demo
//
//  Created by Jerry on 2017/10/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject
@property (nonatomic, readonly) BOOL playing;
- (void)playWithUrl:(NSURL *)url;
- (void)play;
- (void)stop;
- (void)pause;
- (void)adjustPan:(float)pan;
- (void)adjustRate:(float)rate;
- (void)adjustVolume:(float)volume;
@end
