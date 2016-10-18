//
//  AVAudioPlayButton.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/14.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioPlayButton.h"
#import "AVAudioButtonConfigure.h"

#define kWidth  self.frame.size.width
#define kHeight self.frame.size.height
#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degress) ((pi * degress)/180)
#define R

@implementation AVAudioPlayButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.playButtonType = AVAudioPlayButtonTypeLeft;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 0.2f;
    path.lineCapStyle = kCGLineCapRound;
    
    [AudioPlayBorderColor setStroke];
    
    if (self.playButtonType == AAVAudioPlayButtonTypeRight ) {
        [AudioPlayButtonRightColor setFill];
    } else {
//        [AudioPlayButtonLeftColor setFill];
        [AudioPlayButtonRightColor setFill];
        [path moveToPoint:CGPointMake(0, kHeight/2)];
        [path addLineToPoint:CGPointMake(5, kHeight/2 - 5)];
        [path addLineToPoint:CGPointMake(5, 3)];
        [path addArcWithCenter:CGPointMake(8, 3) radius:3.0f startAngle:DEGREES_TO_RADIANS(180.0f) endAngle:DEGREES_TO_RADIANS(270.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(8, 0)];
        [path addLineToPoint:CGPointMake(kWidth - 3, 0)];
        [path addArcWithCenter:CGPointMake(kWidth - 3, 3) radius:3.0f startAngle:DEGREES_TO_RADIANS(270.0f) endAngle:DEGREES_TO_RADIANS(360.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(kWidth, 3)];
        [path addLineToPoint:CGPointMake(kWidth, kHeight - 3)];
        [path addArcWithCenter:CGPointMake(kWidth - 3, kHeight - 3) radius:3.0f startAngle:DEGREES_TO_RADIANS(0.0f) endAngle:DEGREES_TO_RADIANS(90.0f) clockwise:YES];
        
        [path addLineToPoint:CGPointMake(kWidth - 3, kHeight)];
        [path addLineToPoint:CGPointMake(8, kHeight)];
        [path addArcWithCenter:CGPointMake(8, kHeight - 3) radius:3.0f startAngle:DEGREES_TO_RADIANS(90.0f) endAngle:DEGREES_TO_RADIANS(180.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(5, kHeight - 3)];
        [path addLineToPoint:CGPointMake(5, kHeight/2 + 3)];
    }
    
    [path closePath];
    [path fill];
    [path stroke];
}

@end
