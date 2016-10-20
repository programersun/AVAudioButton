//
//  AVAudioView.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/18.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioButtonConfigure.h"

@interface AVAudioView () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVURLAsset    *asset;
@property (strong, nonatomic) UILabel       *timeLabel;
@property (strong, nonatomic) NSTimer       *timer;

- (void)initialize;
- (void)audioPlayBtnClicked:(id)sender;
- (void)audioViewShouldStop:(NSNotification *)notification;

@end

@implementation AVAudioView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.playButton = [[AVAudioPlayButton alloc] init];
    [self.playButton addTarget:self action:@selector(audioPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLabel  = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = AudioTimerColor;
    
    [self addSubview:self.playButton];
    [self addSubview:self.timeLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioViewShouldStop:) name:kFSVoiceBubbleShouldStopNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFSVoiceBubbleShouldStopNotification object:nil];
}

#pragma mark - Nofication

- (void)audioViewShouldStop:(NSNotification *)notification
{
    if (_player.isPlaying) {
        [self stop];
    }
}

#pragma mark - Target Action
- (void)audioPlayBtnClicked:(id)sender {
    if (_player.playing) {
        [self stop];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];
        [self play];
        if (_delegate && [_delegate respondsToSelector:@selector(audioViewDidStartPlaying:)]) {
            [_delegate audioViewDidStartPlaying:self];
        }
    }
}

#pragma mark - Public

- (void)setContentURL:(NSURL *)contentURL
{
//    if (![_contentURL isEqual:contentURL]) {
        _contentURL = contentURL;
        _asset = [[AVURLAsset alloc] initWithURL:_contentURL options:nil];
        CMTime duration = _asset.duration;
        NSInteger seconds = CMTimeGetSeconds(duration);
        NSError *error;
        if (seconds > 60) {
            error = [NSError errorWithDomain:@"A voice audio should't last longer than 60 seconds" code:300 userInfo:nil];
        }
        NSInteger playButtonWidth = 75;
        if (seconds > 3) {
            for (int i = 3; i < seconds; i++) {
                playButtonWidth = playButtonWidth + 1.0 / i * 50;
                if (i + 1 > seconds) {
                    playButtonWidth = playButtonWidth + 1.0 / i * 50 * (seconds - i);
                }
            }
        }
        
        if (playButtonWidth > AVAudioPlayButtonMaxWidth) {
            playButtonWidth = AVAudioPlayButtonMaxWidth;
        }
        
        if (self.playButton.playButtonType == AAVAudioPlayButtonTypeRight) {
            self.playButton.frame = CGRectMake(SCREENWIDTH - 20 - playButtonWidth, 0, playButtonWidth, 40);
            [self.playButton setNeedsLayout];
            self.timeLabel.frame = CGRectMake(self.playButton.frame.origin.x - 50, self.playButton.frame.origin.y + self.playButton.frame.size.height - 22, 45, 20);
            self.timeLabel.textAlignment = NSTextAlignmentRight;
        } else {
            self.playButton.frame = CGRectMake(20, 0, playButtonWidth, 40);
            [self.playButton setNeedsLayout];
            self.timeLabel.frame = CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width + 5, self.playButton.frame.origin.y + self.playButton.frame.size.height - 22, 45, 20);
            self.timeLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        self.timeLabel.text = [NSString stringWithFormat:@"%d\"",(int)seconds];
//    }
}


- (void)prepareToPlay
{
    if (!_player) {
        [_player stop];
        _player = nil;
    }
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_contentURL error:&error];
    _player.delegate = self;
    [_player prepareToPlay];
}

- (void)play
{
    if (!_player) {
        [self prepareToPlay];
    }
    if (!_player.playing) {
        [_player play];
        [self startAnimating];
    }
}

- (void)pause
{
    if (_player.playing) {
        [_player pause];
        [self stopAnimating];
    }
}

- (void)stop
{
    if (_player.playing) {
        [_player stop];
        _player.currentTime = 0;
        [self stopAnimating];
    }
}

- (void)startAnimating {
    __block NSInteger volume = 0;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:YES block:^(NSTimer * _Nonnull timer) {
            volume ++;
            self.playButton.volume = volume;
            [self.playButton setNeedsDisplay];
            if (volume == 3) {
                volume = 0;
            }
        }];
    }
}

- (void)stopAnimating {
    self.playButton.volume = 3;
    [self.playButton setNeedsDisplay];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - AVAudioPlayer Delegate

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    [self play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
