//
//  AVAudioPlayTableViewCell.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/14.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioPlayTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioButtonConfigure.h"

@interface AVAudioPlayTableViewCell ()

@property (nonatomic, strong) AVAudioPlayButton *playBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) float second;

@end

@implementation AVAudioPlayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self durationWithAudio];
        NSInteger playButtonWidth = 75;
        if (self.second > 3) {
            for (int i = 3; i < self.second; i++) {
                playButtonWidth = playButtonWidth + 1/i * 10;
                if (i + 1 > self.second) {
                    playButtonWidth = playButtonWidth + (self.second - i) * 5;
                }
            }
        }
        
        if (self.playButtonType == AAVAudioPlayButtonTypeRight) {
            self.playBtn = [[AVAudioPlayButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 20 - playButtonWidth, 10, playButtonWidth, 40)];
            self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.playBtn.frame.origin.x - 50, 18, 45, 20)];
            self.timeLabel.textAlignment = NSTextAlignmentRight;
        } else {
            self.playBtn = [[AVAudioPlayButton alloc] initWithFrame:CGRectMake(20, 10, 75, 40)];
            self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.playBtn.frame.origin.x + self.playBtn.frame.size.width + 5, 18, 45, 20)];
            self.timeLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = AudioTimerColor;
        self.timeLabel.text = [NSString stringWithFormat:@"%d\"",(int)self.second];
        self.playBtn.playButtonType = self.playButtonType;
        [self addSubview:self.playBtn];
        [self addSubview:self.timeLabel]; 
    }
    return self;
}

- (void)durationWithAudio{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.audioUrl options:opts]; // 初始化视频媒体文件
    self.second = 1.0 * urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
