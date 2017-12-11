//
//  WXHPlayerView.h
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHTransport.h"
#import <AVFoundation/AVFoundation.h>
@interface WXHPlayerView : UIView
@property (nonatomic, weak) id <WXHTransport> transport;
- (id)initWithPlayer:(AVPlayer *)player;

@end
