//
//  AVManager.h
//  WeTransparentChat
//
//  Created by Pandara on 16/8/15.
//  Copyright © 2016年 Pandara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AVManager : NSObject

+ (AVManager *)shareManager;
+ (BOOL)isTPOn;
- (void)startCaptureInView:(UIView *)preview;
- (void)stop;

@end
