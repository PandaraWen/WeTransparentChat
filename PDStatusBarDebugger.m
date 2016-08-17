//
//  PDStatusBarDebugger.m
//  WeTransparentChat
//
//  Created by Pandara on 16/8/16.
//  Copyright © 2016年 Pandara. All rights reserved.
//

#import "PDStatusBarDebugger.h"

@interface PDStatusBarDebugger()

@property (nonatomic) BOOL hasPrepared;
@property (nonatomic, strong) UILabel *debugLabel;

@end

@implementation PDStatusBarDebugger

+ (PDStatusBarDebugger *)defaultDebugger {
    static dispatch_once_t onceToken;
    static PDStatusBarDebugger *manager;
    dispatch_once(&onceToken, ^{
        manager = [PDStatusBarDebugger new];
    });
    
    return manager;
}

- (id)init {
    if (self = [super init]) {
        self.debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 20)];
        self.debugLabel.backgroundColor = [UIColor grayColor];
        self.debugLabel.textColor = [UIColor whiteColor];
        self.debugLabel.numberOfLines = 0;
        self.debugLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return self;
}

- (void)prepareDebugger {
    if (self.hasPrepared) {
        return;
    }
    
    self.hasPrepared = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.debugLabel];
}

- (void)log:(NSString *)message {
    self.debugLabel.text = message;
}

@end
