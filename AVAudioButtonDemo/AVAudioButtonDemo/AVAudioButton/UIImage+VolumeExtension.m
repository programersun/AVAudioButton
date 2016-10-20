//
//  UIImage+VolumeExtension.m
//  AVAudioButtonDemo
//
//  Created by 孙瑞 on 16/10/20.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import "UIImage+VolumeExtension.h"

@implementation UIImage (VolumeExtension)

- (instancetype)imageWithOverlayColor:(UIColor *)overlayColor
{
    UIImage *image = self;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [overlayColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:1.0 orientation: UIImageOrientationDownMirrored];
    
    return flippedImage;
}

@end
