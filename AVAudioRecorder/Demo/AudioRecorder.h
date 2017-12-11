//
//  AudioRecorder.h
//  Demo
//
//  Created by Jerry on 2017/10/29.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RecordingStopCompletionHandler)(BOOL);
typedef void (^RecordingSaveCompletionHandler)(BOOL, id);
@interface AudioRecorder : NSObject
@property (nonatomic, strong, readonly) NSString *formattedCurrentTime;
@property (nonatomic, assign, readonly) BOOL recording;
- (BOOL)record;
- (void)pause;
- (void)stopWithCompletionHandler:(RecordingStopCompletionHandler)handler;
- (void)saveRecordingWithName:(NSString *)name
            CompletionHandler:(RecordingSaveCompletionHandler)handler;
@end
