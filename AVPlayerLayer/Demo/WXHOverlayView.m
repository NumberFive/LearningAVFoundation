//
//  WXHOverlayView.m
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHOverlayView.h"

@implementation WXHOverlayView

- (void)setTitle:(NSString *)time
{
    
}
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration
{
    [self.delegate jumpedToTime:time];
}
- (void)playbackComplete
{
    
}

@end
