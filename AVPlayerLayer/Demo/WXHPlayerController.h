//
//  WXHPlayerController.h
//  Demo
//
//  Created by Jerry on 2017/11/7.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXHPlayerController : NSObject
@property (nonatomic, strong, readonly) UIView *view;
- (id)initWithURL:(NSURL *)assetURL;
@end
