//
//  PDStatusBarDebugger.h
//  WeTransparentChat
//
//  Created by Pandara on 16/8/16.
//  Copyright © 2016年 Pandara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDStatusBarDebugger : NSObject

+ (PDStatusBarDebugger *)defaultDebugger;
- (void)prepareDebugger;
- (void)log:(NSString *)message;

@end
