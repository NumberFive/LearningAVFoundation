//
//  ViewController.m
//  Demo
//
//  Created by Jerry on 2017/10/29.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"

#import "AudioRecorder.h"
@interface ViewController ()

@property (nonatomic, strong) AudioRecorder *recorder;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[paths firstObject]);
    
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    
    self.timeLabel.frame = CGRectMake(10, 100, 300, 50);
    self.startButton.frame = CGRectMake(10, 200, 100, 44);
    self.stopButton.frame = CGRectMake(130, 200, 100, 44);
    
    [self.recorder addObserver:self forKeyPath:@"recording" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.recorder) {
        if (self.recorder.recording) {
            [self.startButton setTitle:@"暂停" forState:UIControlStateNormal];
            self.startButton.selected = YES;
            [self startTimer];
        } else {
            [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
            self.startButton.selected = NO;
            [self cancleTimer];
        }
    }
}
- (void)startButtonAction
{
    if (self.startButton.selected) {
        [self.recorder pause];
    } else {
        [self.recorder record];
    }
}
- (void)stopButtonAction
{
    __weak ViewController *vc = self;
    [_recorder stopWithCompletionHandler:^(BOOL finished) {
        __strong ViewController *vc2 = vc;
        if (finished) {
            [vc2.recorder saveRecordingWithName:@"hello" CompletionHandler:^(BOOL completion, id result) {
                if (completion) {
                    NSLog(@"%@",result);
                } else {
                    NSError *error = (NSError *)result;
                    NSLog(@"Save Recording Error:%@",[error localizedDescription]);
                }
            }];
        }
    }];
}
- (void)startTimer
{
    [self timer];
}
- (void)cancleTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)updateTimeDisplay
{
    self.timeLabel.text = self.recorder.formattedCurrentTime;
}
#pragma mark - Setter / Getter
- (AudioRecorder *)recorder
{
    if (!_recorder) {
        _recorder = [[AudioRecorder alloc] init];
    }
    return _recorder;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.text = @"00:00:00";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = [UIColor brownColor];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}
- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopButton.backgroundColor = [UIColor brownColor];
        [_stopButton setTitle:@"停止" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

@end
