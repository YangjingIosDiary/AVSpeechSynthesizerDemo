//
//  ViewController.m
//  AVSpeechSynthesizerDemo
//
//  Created by Yang on 2019/1/25.
//  Copyright © 2019 YangJing. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textView.editable = NO;
}

- (IBAction)confirmAction:(id)sender {
    if (!self.synthesizer) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
    }
    
    if (self.synthesizer.isPaused) {
        [self.synthesizer continueSpeaking];
        return;
        
    } else if (self.synthesizer.isSpeaking) {
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        return;
    }
    
    NSArray *speechUtterancesArray = @[@"南柯子·怅望梅花驿",
                                       @"宋代：范成大",
                                       @"怅望梅花驿，凝情杜若洲。香云低处有高楼，可惜高楼不近木兰舟。",
                                       @"缄素双鱼远，题红片叶秋。欲凭江水寄离愁，江已东流那肯更西流。"];
    
    for (NSString *speechUtteranceStr in speechUtterancesArray) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:speechUtteranceStr];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        utterance.rate = 0.5f;
        utterance.pitchMultiplier = 0.8f;
        utterance.postUtteranceDelay = 0.1f;
        utterance.preUtteranceDelay = 0.0f;
        utterance.volume = 1.0f;
        [self.synthesizer speakUtterance:utterance];
    }
}

//开始朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"yangjing: didStartSpeechUtterance");
    [self.confirmBtn setTitle:@"暂停" forState:UIControlStateNormal];
}
//结束朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"yangjing: didFinishSpeechUtterance");
    [self.confirmBtn setTitle:@"开始" forState:UIControlStateNormal];

}
//暂停朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"yangjing: didPauseSpeechUtterance");
    [self.confirmBtn setTitle:@"继续" forState:UIControlStateNormal];
}
//继续朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"yangjing: didContinueSpeechUtterance-");
    [self.confirmBtn setTitle:@"暂停" forState:UIControlStateNormal];
}
//取消朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"yangjing: didCancelSpeechUtterance");
    [self.confirmBtn setTitle:@"开始" forState:UIControlStateNormal];
}
//将要播放的语音文字
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    NSLog(@"willSpeakRangeOfSpeechString->characterRange.location = %zd->characterRange.length = %zd->utterance.speechString= %@",characterRange.location,characterRange.length,utterance.speechString);
}

@end
