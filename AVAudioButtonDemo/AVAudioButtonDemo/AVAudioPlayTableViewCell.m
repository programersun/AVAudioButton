//
//  AVAudioPlayTableViewCell.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/18.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioPlayTableViewCell.h"
#import "AVAudioButtonConfigure.h"

@implementation AVAudioPlayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.audioView = [[AVAudioView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 40)];
        [self addSubview:self.audioView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
