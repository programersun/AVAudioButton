//
//  AVAudioVolumeView.m
//  AVAudioDemo
//
//  Created by 孙瑞 on 16/10/10.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioVolumeView.h"

@implementation AVAudioVolumeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.volume = 1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 1.获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.拼接图形(路径)
    // 设置线段宽度
    CGContextSetLineWidth(ctx, 3);
    
    // 设置线段头尾部的样式
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    // 设置颜色
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    
    for (int i = 0; i < self.volume; i++) {
        if (i > 8) {
            return;
        }
        // 设置一个起点
        CGContextMoveToPoint(ctx, 0, self.frame.size.height - 2 * (i + 1) - 5 * i);

        CGContextAddLineToPoint(ctx, 8 + i * 2, self.frame.size.height - 2 * (i + 1) - 5 * i);
        CGContextStrokePath(ctx);
    }
}

@end
