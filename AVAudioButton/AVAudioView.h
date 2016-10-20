//
//  AVAudioView.h
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/18.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVAudioPlayButton.h"

@class AVAudioView;

@protocol AVAudioViewDelegate <NSObject>

- (void)audioViewDidStartPlaying:(AVAudioView *)audioView;

@end

@interface AVAudioView : UIView

@property (nonatomic, strong) NSURL *contentURL;
@property (nonatomic, strong) AVAudioPlayButton *playButton;
@property (nonatomic, assign) IBOutlet id<AVAudioViewDelegate> delegate;

- (void)prepareToPlay;
- (void)play;
- (void)stop;

- (void)startAnimating;
- (void)stopAnimating;

@end
