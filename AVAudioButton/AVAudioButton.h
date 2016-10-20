//
//  AVAudioButton.h
//  AVAudioDemo
//
//  Created by 孙瑞 on 16/10/10.
//  Copyright © 2016年 济南东晨信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AVAudioButtonDelegate <NSObject>
@optional

- (void)cancelAVAudioButtonDelegate;
- (void)successAVAudioButtonDelegate:(NSURL *)recorderUrl success:(BOOL)success;

@end

@interface AVAudioButton : UIButton

@property (nonatomic, weak, nullable) id <AVAudioButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
