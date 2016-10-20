//
//  AVAudioPlayButton.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/14.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "AVAudioPlayButton.h"
#import "AVAudioButtonConfigure.h"
#import <AVFoundation/AVFoundation.h>

#define kWidth  self.frame.size.width
#define kHeight self.frame.size.height
#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degress) ((pi * degress)/180)
#define R

@implementation AVAudioPlayButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.playButtonType = AVAudioPlayButtonTypeLeft;
        self.volume = 3;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = 0.3f;
    path.lineCapStyle = kCGLineCapRound;
    
    [AudioPlayBorderColor setStroke];
    
    if (self.playButtonType == AAVAudioPlayButtonTypeRight ) {
        [AudioPlayButtonRightColor setFill];
        [path moveToPoint:CGPointMake(kWidth - path.lineWidth, kHeight/2)];
        [path addLineToPoint:CGPointMake(kWidth - 5, kHeight/2 + 6)];
        [path addLineToPoint:CGPointMake(kWidth - 5, kHeight - 4 - path.lineWidth)];
        [path addArcWithCenter:CGPointMake(kWidth - 9, kHeight - 4 - path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(0.0f) endAngle:DEGREES_TO_RADIANS(90.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(kWidth - 9, kHeight - path.lineWidth)];
        [path addLineToPoint:CGPointMake(4 + path.lineWidth, kHeight - path.lineWidth)];
        [path addArcWithCenter:CGPointMake(4 + path.lineWidth, kHeight - 4 - path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(90.0f) endAngle:DEGREES_TO_RADIANS(180.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(0 + path.lineWidth, kHeight - 4 - path.lineWidth)];
        [path addLineToPoint:CGPointMake(0 + path.lineWidth, 4 + path.lineWidth)];
        [path addArcWithCenter:CGPointMake(4 + path.lineWidth, 4 + path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(180.0f) endAngle:DEGREES_TO_RADIANS(270.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(4 + path.lineWidth, 0 + path.lineWidth)];
        [path addLineToPoint:CGPointMake(kWidth - 9 - path.lineWidth, 0 + path.lineWidth)];
        [path addArcWithCenter:CGPointMake(kWidth - 9, 4 + path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(270.0f) endAngle:DEGREES_TO_RADIANS(360.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(kWidth - 5, 4 + path.lineWidth)];
        [path addLineToPoint:CGPointMake(kWidth - 5, kHeight/2 - 6)];
    } else {
        [AudioPlayButtonLeftColor setFill];
        [path moveToPoint:CGPointMake(0 + path.lineWidth, kHeight/2)];
        [path addLineToPoint:CGPointMake(5, kHeight/2 - 6)];
        [path addLineToPoint:CGPointMake(5, 4 + path.lineWidth)];
        [path addArcWithCenter:CGPointMake(9, 4 + path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(180.0f) endAngle:DEGREES_TO_RADIANS(270.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(9, 0 + path.lineWidth)];
        [path addLineToPoint:CGPointMake(kWidth - 4 - path.lineWidth, 0 + path.lineWidth)];
        [path addArcWithCenter:CGPointMake(kWidth - 4 - path.lineWidth, 4 + path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(270.0f) endAngle:DEGREES_TO_RADIANS(360.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(kWidth - path.lineWidth, 4 + path.lineWidth)];
        [path addLineToPoint:CGPointMake(kWidth - path.lineWidth, kHeight - 4 - path.lineWidth)];
        [path addArcWithCenter:CGPointMake(kWidth - 4 - path.lineWidth, kHeight - 4 - path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(0.0f) endAngle:DEGREES_TO_RADIANS(90.0f) clockwise:YES];
        
        [path addLineToPoint:CGPointMake(kWidth - 4 - path.lineWidth, kHeight - path.lineWidth)];
        [path addLineToPoint:CGPointMake(9, kHeight - path.lineWidth)];
        [path addArcWithCenter:CGPointMake(9, kHeight - 4 - path.lineWidth) radius:4.0f startAngle:DEGREES_TO_RADIANS(90.0f) endAngle:DEGREES_TO_RADIANS(180.0f) clockwise:YES];
        [path addLineToPoint:CGPointMake(5, kHeight - 4 - path.lineWidth)];
        [path addLineToPoint:CGPointMake(5, kHeight/2 + 6)];
    }
    
    [path closePath];
    [path fill];
    [path stroke];
    
    
    UIBezierPath *volumePath1 = [[UIBezierPath alloc] init];
    volumePath1.lineWidth = 3.0f;
    volumePath1.lineCapStyle = kCGLineCapSquare;
    [AudioPlayBorderColor setFill];
    
    UIBezierPath *volumePath2 = [[UIBezierPath alloc] init];
    volumePath2.lineWidth = 2.0f;
    volumePath2.lineCapStyle = kCGLineCapSquare;
    [AudioPlayBorderColor setStroke];

    UIBezierPath *volumePath3 = [[UIBezierPath alloc] init];
    
    volumePath3.lineWidth = 2.0f;
    volumePath3.lineCapStyle = kCGLineCapSquare;
    [AudioPlayBorderColor setStroke];

    float radius = 0.0f;
    if (self.playButtonType == AAVAudioPlayButtonTypeRight ) {
        
        if (self.volume >= 1) {
            radius = 4.0f;
            [volumePath1 moveToPoint:CGPointMake(kWidth - 20, kHeight/2)];
            [volumePath1 addArcWithCenter:CGPointMake(kWidth - 20, kHeight/2) radius:radius startAngle:DEGREES_TO_RADIANS(145.0f) endAngle:DEGREES_TO_RADIANS(225.0f) clockwise:YES];
        }
        if (self.volume >= 2) {
            radius = 8.0f;
            [volumePath2 moveToPoint:CGPointMake(kWidth - 20 - sqrtf(powf(radius, 2)/2), kHeight/2 + sqrtf(powf(radius, 2)/2))];
            [volumePath2 addArcWithCenter:CGPointMake(kWidth - 20, kHeight/2) radius:radius startAngle:DEGREES_TO_RADIANS(145.0f) endAngle:DEGREES_TO_RADIANS(225.0f) clockwise:YES];
        }
        if (self.volume >= 3) {
            
            radius = 13.0f;
            [volumePath3 moveToPoint:CGPointMake(kWidth - 20 - sqrtf(powf(radius, 2)/2), kHeight/2 + sqrtf(powf(radius, 2)/2))];
            [volumePath3 addArcWithCenter:CGPointMake(kWidth - 20, kHeight/2) radius:radius startAngle:DEGREES_TO_RADIANS(145.0f) endAngle:DEGREES_TO_RADIANS(225.0f) clockwise:YES];
        }
        
    } else {
        
        if (self.volume >= 1) {
            radius = 4.0f;
            [volumePath1 moveToPoint:CGPointMake(20, kHeight/2)];
            [volumePath1 addArcWithCenter:CGPointMake(20, kHeight/2) radius:radius startAngle:DEGREES_TO_RADIANS(315.0f) endAngle:DEGREES_TO_RADIANS(45.0f) clockwise:YES];
        }
        if (self.volume >= 2) {
            radius = 8.0f;
            [volumePath2 moveToPoint:CGPointMake(20 + sqrtf(powf(radius, 2)/2), kHeight/2 - sqrtf(powf(radius, 2)/2))];
            [volumePath2 addArcWithCenter:CGPointMake(20, kHeight/2) radius:radius startAngle:DEGREES_TO_RADIANS(315.0f) endAngle:DEGREES_TO_RADIANS(45.0f) clockwise:YES];
        }
        if (self.volume >= 3) {
            
            radius = 13.0f;
            [volumePath3 moveToPoint:CGPointMake(20 + sqrtf(powf(radius, 2)/2), kHeight/2 - sqrtf(powf(radius, 2)/2))];
            [volumePath3 addArcWithCenter:CGPointMake(20, kHeight/2) radius:radius startAngle:DEGREES_TO_RADIANS(315.0f) endAngle:DEGREES_TO_RADIANS(45.0f) clockwise:YES];
        }
    }
    [volumePath1 fill];
    [volumePath2 stroke];
    [volumePath3 stroke];

}

@end
