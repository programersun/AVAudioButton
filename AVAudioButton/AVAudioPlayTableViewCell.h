//
//  AVAudioPlayTableViewCell.h
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/14.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVAudioPlayButton.h"

@interface AVAudioPlayTableViewCell : UITableViewCell

@property (nonatomic, strong) NSURL *audioUrl;
@property (nonatomic, assign) AVAudioPlayButtonType playButtonType;

@end
