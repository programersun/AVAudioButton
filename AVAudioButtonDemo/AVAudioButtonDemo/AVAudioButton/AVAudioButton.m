//
//  AVAudioButton.m
//  AVAudioDemo
//
//  Created by 孙瑞 on 16/10/10.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AVAudioVolumeView.h"
#import "AVAudioButtonConfigure.h"

@interface AVAudioButton () <AVAudioRecorderDelegate>
{
//    AVAudioRecorder *_recorder;
    NSTimer *_timer;
    NSURL *_recorderUrl;
}

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UIView *AVAudioView;
@property (nonatomic, strong) UIView *stateView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *successView;
@property (nonatomic, strong) AVAudioVolumeView *volumeView;
@property (nonatomic, strong) UIImageView *cancelView;

@end

@implementation AVAudioButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame
{
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(cancelPass: withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(cancelPass: withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchDragOutside: withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(touchDragInside: withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    self.selected = NO;
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}

- (void)setAVAudioView {
    
    self.AVAudioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.AVAudioView];
    self.AVAudioView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    backgroundView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.5f;
    backgroundView.layer.cornerRadius = 5.0f;
    [self.AVAudioView addSubview:backgroundView];
    
    self.stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.stateView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    self.stateView.backgroundColor = [UIColor clearColor];
    self.stateView.layer.cornerRadius = 5.0f;
    [self.AVAudioView addSubview:self.stateView];
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 150 - 30, 150 - 10, 25)];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.stateLabel.layer.cornerRadius = 5.0f;
    self.stateLabel.layer.masksToBounds = YES;
    self.stateLabel.backgroundColor = [UIColor clearColor];
    self.stateLabel.text = @"手指上滑，取消录音";
    [self.stateView addSubview:self.stateLabel];
    
    self.cancelView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    self.cancelView.center = CGPointMake(self.stateView.frame.size.width / 2 - 5, (self.stateView.frame.size.height - 20) / 2);
    self.cancelView.image = [UIImage imageNamed:@"cancelAVAudio"];
    self.cancelView.hidden = YES;
    [self.stateView addSubview:self.cancelView];
    
    self.successView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 120)];
    self.successView.backgroundColor = [UIColor clearColor];
    [self.stateView addSubview:self.successView];
    UIImageView *microphone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    microphone.center = CGPointMake(self.stateView.frame.size.width / 2 - 20, (self.stateView.frame.size.height - 20) / 2);
    microphone.image = [UIImage imageNamed:@"microphone"];
    [self.successView addSubview:microphone];
    
    self.volumeView = [[AVAudioVolumeView alloc] initWithFrame:CGRectMake(0, 0, 50, 76)];
    self.volumeView.center = CGPointMake(self.stateView.frame.size.width / 2 + 40, (self.stateView.frame.size.height - 30) / 2);
    [self.successView addSubview:self.volumeView];
}

- (void)setCancelView {
    self.stateLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.stateLabel.text = @"松开手指，取消录音";
    self.cancelView.hidden = NO;
    self.successView.hidden = YES;
    self.stateLabel.backgroundColor = [UIColor redColor];
}

- (void)setMoveView {
    self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.stateLabel.text = @"手指上滑，取消录音";
    self.cancelView.hidden = YES;
    self.successView.hidden = NO;
    self.stateLabel.backgroundColor = [UIColor clearColor];
}

- (void)setRecorder
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    strUrl = [strUrl stringByAppendingPathComponent:@"recorder"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strUrl]) {
        [fileManager createDirectoryAtPath:strUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.aac", strUrl,fileName]];
    _recorderUrl = url;
    
    NSError *error;
    
    //初始化
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    [[AVAudioSession sharedInstance]  setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
}


- (void)startRecorder {
    
    [self setRecorder];
    //创建录音文件，准备录音
    
    if (![_recorder isRecording]) {
        [_recorder prepareToRecord];
        [_recorder record];
        //设置定时检测
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

- (void)detectionVoice
{
    [_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0])) * 40;
    NSLog(@"%f",lowPassResults);
    if (lowPassResults < 1) {
        lowPassResults = 1;
    }
    [self changeVolumeValue:(NSInteger)lowPassResults];
}


#pragma mark - 手指按下
- (void)touchDown:(UIButton *)sender {
    self.selected = YES;
    [self setAVAudioView];
    [self startRecorder];
    [self setTitle:@"松开 结束" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];
}

#pragma mark - 手指松开
- (void)cancelPass:(UIButton *)sender withEvent:(UIEvent*)event {
    self.selected = NO;
    self.AVAudioView.hidden = YES;
    [self.AVAudioView removeFromSuperview];
    self.stateLabel = nil;
    self.stateView = nil;
    self.successView = nil;
    self.cancelView = nil;
    self.AVAudioView = nil;
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int currentY = point.y;
    
    double cTime = _recorder.currentTime;
    
    [_recorder stop];
    [_timer invalidate];
    
    if (currentY < - CANCELDISTANCE) {
        //cancel
        //删除记录的文件
        [_recorder deleteRecording];
        
        if (self.delegate) {
            [self.delegate cancelAVAudioButtonDelegate];
        }
        
    } else if (currentY > - CANCELDISTANCE) {
        //success
        if (self.delegate) {
            if (cTime > 2) {
                [self.delegate successAVAudioButtonDelegate:_recorderUrl success:YES];
            } else {
                [self.delegate successAVAudioButtonDelegate:_recorderUrl success:NO];
                [_recorder deleteRecording];
            }
        }
    }
    
}

#pragma mark - 从按钮内部滑动到外部
- (void)touchDragOutside:(UIButton *)sender withEvent:(UIEvent*)event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int currentY = point.y;
    if (currentY < - CANCELDISTANCE) {
        [self setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self setCancelView];
    } else if (currentY > - CANCELDISTANCE) {
        [self setMoveView];
    }
}

#pragma mark - 从按钮外部滑动到内部
- (void)touchDragInside:(UIButton *)sender withEvent:(UIEvent*)event {
    [self setMoveView];
}

- (void)changeVolumeValue:(NSInteger)volume {
    self.volumeView.volume = volume;
    [self.volumeView setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
