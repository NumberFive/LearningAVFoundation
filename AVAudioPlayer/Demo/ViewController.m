//
//  ViewController.m
//  Demo
//
//  Created by Jerry on 2017/10/28.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayer.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) UISlider *panSlider;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UISlider *rateSlider;

@property (nonatomic, strong) UILabel *panLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *rateLabel;

@property (nonatomic, strong) AudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViews];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Happy" withExtension:@"mp3"];
    if (url) {
        [self.audioPlayer playWithUrl:url];
    }
    [self.audioPlayer addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)dealloc
{
    [self.audioPlayer removeObserver:self forKeyPath:@"playing"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.audioPlayer) {
        self.playButton.selected = !self.audioPlayer.playing;
    }
}

- (void)customViews
{
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.panSlider];
    [self.view addSubview:self.panLabel];
    [self.view addSubview:self.volumeSlider];
    [self.view addSubview:self.volumeLabel];
    [self.view addSubview:self.rateSlider];
    [self.view addSubview:self.rateLabel];
    
    self.playButton.frame = CGRectMake(10, 100, 80, 40);
    self.stopButton.frame = CGRectMake(100, 100, 80, 40);
    
    self.panSlider.frame = CGRectMake(10, 200, 200, 44);
    self.panLabel.frame = CGRectMake(220, 200, 150, 44);
    self.volumeSlider.frame = CGRectMake(10, 250, 200, 44);
    self.volumeLabel.frame = CGRectMake(220, 250, 150, 44);
    self.rateSlider.frame = CGRectMake(10, 300, 200, 44);
    self.rateLabel.frame = CGRectMake(220, 300, 150, 44);
}

- (void)playButtonAction
{
    if (!self.playButton.selected) {
        [self.audioPlayer pause];
    } else {
        [self.audioPlayer play];
    }
}
- (void)stopButtonAction
{
    [self.audioPlayer stop];
}
- (void)sliderAction:(UISlider *)slider
{
    if (slider == self.panSlider) {
        self.panLabel.text = [NSString stringWithFormat:@"声道:%0.2f",self.panSlider.value];
        [self.audioPlayer adjustPan:self.panSlider.value];
    } else if (slider == self.volumeSlider) {
        self.volumeLabel.text = [NSString stringWithFormat:@"音量:%0.2f",self.volumeSlider.value];
        [self.audioPlayer adjustVolume:self.volumeSlider.value];
    } else if (slider == self.rateSlider) {
        self.rateLabel.text = [NSString stringWithFormat:@"速率:%0.2f",self.rateSlider.value];
        [self.audioPlayer adjustRate:self.rateSlider.value];
    }
}
#pragma mark - Setter / Getter
- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"暂停" forState:UIControlStateSelected];
        _playButton.backgroundColor = [UIColor brownColor];
        [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setTitle:@"停止" forState:UIControlStateNormal];
        _stopButton.backgroundColor = [UIColor brownColor];
        [_stopButton addTarget:self action:@selector(stopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}
- (UISlider *)panSlider
{
    if (!_panSlider) {
        _panSlider = [[UISlider alloc] init];
        _panSlider.minimumValue = -1.0;
        _panSlider.maximumValue = 1.0;
        _panSlider.value = 0.0;
        [_panSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _panSlider;
}
- (UISlider *)volumeSlider
{
    if (!_volumeSlider) {
        _volumeSlider = [[UISlider alloc] init];
        _volumeSlider.minimumValue = 0.0;
        _volumeSlider.maximumValue = 1.0;
        _volumeSlider.value = 0.4;
        [_volumeSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _volumeSlider;
}
- (UISlider *)rateSlider
{
    if (!_rateSlider) {
        _rateSlider = [[UISlider alloc] init];
        _rateSlider.minimumValue = 0.5;
        _rateSlider.maximumValue = 2.0;
        _rateSlider.value = 1.0;
        [_rateSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _rateSlider;
}

- (UILabel *)panLabel
{
    if (!_panLabel) {
        _panLabel = [[UILabel alloc] init];
        _panLabel.text = @"声道";
    }
    return _panLabel;
}
- (UILabel *)volumeLabel
{
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.text = @"音量";
    }
    return _volumeLabel;
}
- (UILabel *)rateLabel
{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.text = @"速率";
    }
    return _rateLabel;
}
- (AudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    return _audioPlayer;
}

@end
