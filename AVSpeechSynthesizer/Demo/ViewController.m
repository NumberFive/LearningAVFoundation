//
//  ViewController.m
//  Demo
//
//  Created by Jerry on 2017/10/27.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Speech" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 200,50);
    button.center = self.view.center;
    button.backgroundColor = [UIColor brownColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonAction
{
    //说话方式
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"hello AV Foundation !"];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];//语言
    utterance.rate = 0.4f;//速率,0.0~1.0之间
    utterance.pitchMultiplier = 0.8f;//音调，0.5~2.0
    utterance.postUtteranceDelay = 0.1f;//停顿
    [self.synthesizer speakUtterance:utterance];
}


#pragma mark - Setter / Getter
- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];//合成器
    }
    return _synthesizer;
}

@end
