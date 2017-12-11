//
//  WXHMediaItem.h
//  Demo
//
//  Created by Jerry on 2017/11/3.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXHMetadata.h"

typedef void(^WXHCompletionHandler)(BOOL complete);
@interface WXHMediaItem : NSObject
@property (nonatomic, copy, readonly) NSString *filename;
@property (nonatomic, copy, readonly) NSString *filetype;
@property (nonatomic, strong, readonly) WXHMetadata *metadata;
@property (nonatomic, assign, readonly, getter=isEditable) BOOL editable;

- (id)initWithURL:(NSURL *)url;
- (void)prepareWithCompletionHandler:(WXHCompletionHandler)handler;
- (void)saveWithCompletionHandler:(WXHCompletionHandler)handler;
@end
