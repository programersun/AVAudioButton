//
//  AVAudioPlayButton.h
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/14.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AVAudioPlayButtonTypeLeft,
    AAVAudioPlayButtonTypeRight
} AVAudioPlayButtonType;

@interface AVAudioPlayButton : UIView

@property (nonatomic, assign) AVAudioPlayButtonType playButtonType;

@end
