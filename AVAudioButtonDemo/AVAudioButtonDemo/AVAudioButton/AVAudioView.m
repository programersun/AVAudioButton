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
#import "UIImage+VolumeExtension.h"

@interface AVAudioView () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVURLAsset    *asset;
@property (strong, nonatomic) UILabel       *timeLabel;
@property (strong, nonatomic) UIImageView   *volumeImageView;
- (void)initialize;
- (void)audioPlayBtnClicked:(id)sender;
- (void)audioPlayBtnLongPassed:(UILongPressGestureRecognizer *)gestureRecognizer;
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

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioPlayBtnClicked:)];
    [self.playButton addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(audioPlayBtnLongPassed:)];
    longPress.minimumPressDuration = 1.0f;
    [self.playButton addGestureRecognizer:longPress];
    
    self.timeLabel  = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = AudioTimerColor;
    
    _animatingWaveColor = AudioPlayBorderColor;
    self.waveColor = AudioPlayBorderColor;
    self.volumeImageView = [[UIImageView alloc] init];
    self.volumeImageView.animationDuration = 2.0f;
    self.volumeImageView.animationRepeatCount = 30;
    
    [self addSubview:self.playButton];
    [self addSubview:self.timeLabel];
    [self addSubview:self.volumeImageView];
    
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

- (void)audioPlayBtnLongPassed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (_player.playing) {
        [self stop];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(audioPlayBtnLongPass:)]) {
        [_delegate audioPlayBtnLongPass:self];
    }
}

# pragma mark - Setter & Getter
- (void)setWaveColor:(UIColor *)waveColor
{
    if (![_waveColor isEqual:waveColor]) {
        _waveColor = waveColor;
    }
}

#pragma mark - Public

- (void)setContentURL:(NSURL *)contentURL
{
//    if (![_contentURL isEqual:contentURL]) {
        _contentURL = contentURL;
        _asset = [[AVURLAsset alloc] initWithURL:_contentURL options:nil];
//        CMTime duration = _asset.duration;
//        NSInteger seconds = CMTimeGetSeconds(duration);
//        NSError *error;
//        if (seconds > 60) {
//            error = [NSError errorWithDomain:@"A voice audio should't last longer than 60 seconds" code:300 userInfo:nil];
//        }
//        NSInteger playButtonWidth = 75;
//        if (seconds > 3) {
//            for (int i = 3; i < seconds; i++) {
//                playButtonWidth = playButtonWidth + 1.0 / i * 50;
//                if (i + 1 > seconds) {
//                    playButtonWidth = playButtonWidth + 1.0 / i * 50 * (seconds - i);
//                }
//            }
//        }
//        
//        if (playButtonWidth > AVAudioPlayButtonMaxWidth) {
//            playButtonWidth = AVAudioPlayButtonMaxWidth;
//        }
//        
//        if (self.playButton.playButtonType == AAVAudioPlayButtonTypeRight) {
//            self.playButton.frame = CGRectMake(SCREENWIDTH - 20 - playButtonWidth, 0, playButtonWidth, 40);
//            [self.playButton setNeedsLayout];
//            self.timeLabel.frame = CGRectMake(self.playButton.frame.origin.x - 50, self.playButton.frame.origin.y + self.playButton.frame.size.height - 22, 45, 20);
//            self.timeLabel.textAlignment = NSTextAlignmentRight;
//            self.volumeImageView.frame = CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width - 40, (self.playButton.frame.size.height - 25) / 2, 25, 25);
//            self.volumeImageView.image = [UIImageNamed(@"volume_icon_wave_2.png") imageWithOverlayColor:_waveColor];
//            self.volumeImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
//        } else {
//            self.playButton.frame = CGRectMake(20, 0, playButtonWidth, 40);
//            [self.playButton setNeedsLayout];
//            self.timeLabel.frame = CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width + 5, self.playButton.frame.origin.y + self.playButton.frame.size.height - 22, 45, 20);
//            self.timeLabel.textAlignment = NSTextAlignmentLeft;
//            self.volumeImageView.frame = CGRectMake(35, (self.playButton.frame.size.height - 25) / 2, 25, 25);
//            self.volumeImageView.image = [UIImageNamed(@"volume_icon_wave_2.png") imageWithOverlayColor:_waveColor];
//        }
//        
//        self.timeLabel.text = [NSString stringWithFormat:@"%d\"",(int)seconds];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
        self.volumeImageView.frame = CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width - 40, (self.playButton.frame.size.height - 25) / 2, 25, 25);
        self.volumeImageView.image = [UIImageNamed(@"volume_icon_wave_2.png") imageWithOverlayColor:_waveColor];
        self.volumeImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
    } else {
        self.playButton.frame = CGRectMake(20, 0, playButtonWidth, 40);
        [self.playButton setNeedsLayout];
        self.timeLabel.frame = CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width + 5, self.playButton.frame.origin.y + self.playButton.frame.size.height - 22, 45, 20);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.volumeImageView.frame = CGRectMake(self.playButton.frame.origin.x + 15, (self.playButton.frame.size.height - 25) / 2, 25, 25);
        self.volumeImageView.image = [UIImageNamed(@"volume_icon_wave_2.png") imageWithOverlayColor:_waveColor];
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d\"",(int)seconds];
}


- (void)prepareToPlay
{
    if (!_player) {
        [_player stop];
        _player = nil;
    }
    NSError *error;
    
    if ([[NSString stringWithFormat:@"%@",_contentURL] hasPrefix:@"http"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",_contentURL];
        NSRange range = [urlStr rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *fileName = [urlStr substringWithRange:NSMakeRange(range.location + 1, urlStr.length - range.location - 1)];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        strUrl = [strUrl stringByAppendingPathComponent:@"download"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:strUrl]) {
            [fileManager createDirectoryAtPath:strUrl withIntermediateDirectories:YES attributes:nil error:nil];
        }
        strUrl = [strUrl stringByAppendingPathComponent:fileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:strUrl]) {
            NSURL *url = [[NSURL alloc]initWithString:urlStr];
            NSData * audioData = [NSData dataWithContentsOfURL:url];
            [audioData writeToFile:strUrl atomically:YES];
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl] error:&error];
    } else {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_contentURL error:&error];
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    
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

    if (!_volumeImageView.isAnimating) {
        UIImage *image0 = [UIImageNamed(@"volume_icon_wave_0.png") imageWithOverlayColor:_animatingWaveColor];
        UIImage *image1 = [UIImageNamed(@"volume_icon_wave_1.png") imageWithOverlayColor:_animatingWaveColor];
        UIImage *image2 = [UIImageNamed(@"volume_icon_wave_2.png") imageWithOverlayColor:_animatingWaveColor];
        self.volumeImageView.animationImages = @[image0, image1, image2];
        [self.volumeImageView startAnimating];
    }
    
}

- (void)stopAnimating {

    if (self.volumeImageView.isAnimating) {
        [self.volumeImageView stopAnimating];
    }
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
    if (_delegate && [_delegate respondsToSelector:@selector(audioViewDidEndPlaying:)]) {
        [_delegate audioViewDidEndPlaying:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
