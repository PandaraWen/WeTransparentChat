//
//  AVManager.m
//  WeTransparentChat
//
//  Created by Pandara on 16/8/15.
//  Copyright © 2016年 Pandara. All rights reserved.
//

#import "AVManager.h"
#import "PDStatusBarDebugger.h"

@interface AVManager() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak) UIView *preview;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation AVManager

+ (AVManager *)shareManager {
    static dispatch_once_t onceToken;
    static AVManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [AVManager new];
    });
    
    return manager;
}

#pragma mark - Private Methods


#pragma mark - Methods
- (void)startCaptureInView:(UIView *)preview {
    if (self.session.isRunning) {
        return;
    }
    
    self.preview = preview;
    for (UIView *subView in preview.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            self.tableView = (UITableView *)subView;
            break;
        }
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //setup avfoundation
    self.session = [AVCaptureSession new];
    [self.session beginConfiguration];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
        [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    } else {
        NSLog(@"Cant set preset!");
    }
    
    //input
    NSError *error = nil;
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (error) {
        NSLog(@"Get input error: %@", error.localizedDescription);
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    } else {
        NSLog(@"Cant add input");
    }
    
    AVCaptureVideoDataOutput *output = [AVCaptureVideoDataOutput new];
    output.videoSettings =@{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    dispatch_queue_t videoQueue = dispatch_queue_create("com.pandara.video", DISPATCH_QUEUE_SERIAL);
    [output setSampleBufferDelegate:self queue:videoQueue];
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    } else {
        NSLog(@"Cant add output");
    }
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = preview.bounds;
    [self.preview.layer insertSublayer:self.previewLayer below:self.tableView.layer];
    AVCaptureConnection *previewLayerConnection = self.previewLayer.connection;
    
    if ([previewLayerConnection isVideoOrientationSupported]) {
        UIInterfaceOrientation appOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        AVCaptureVideoOrientation orientation;
        
        switch (appOrientation) {
            case UIInterfaceOrientationPortrait:
                orientation = AVCaptureVideoOrientationPortrait;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                orientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeRight:
                orientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                orientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                orientation = AVCaptureVideoOrientationPortrait;
                break;
        }
        [previewLayerConnection setVideoOrientation:orientation];
    }
    
    [self.session commitConfiguration];
    [self.session startRunning];
}

- (void)stop {
    if (!self.session.isRunning) {
        return;
    }
    
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    self.session = nil;
    self.previewLayer = nil;
    self.preview = nil;
}

+ (BOOL)isTPOn {
    BOOL isTPOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PANDARA_TP_ON"] boolValue];
    return isTPOn;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
}

@end










