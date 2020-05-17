//
//  RCTStream.m
//  RCTLFLiveKit
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

#import <React/RCTBridge.h>
#import "LFLiveSession.h"
#import "RCTStream.h"
#import "RCTStreamManager.h"
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

@interface RCTStream () <LFLiveSessionDelegate>

@property (nonatomic, weak) RCTStreamManager *manager;
@property (nonatomic, weak) RCTBridge *bridge;
@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) RCTDirectEventBlock onReady;
@property (nonatomic, copy) RCTDirectEventBlock onPending;
@property (nonatomic, copy) RCTDirectEventBlock onStart;
@property (nonatomic, copy) RCTDirectEventBlock onError;
@property (nonatomic, copy) RCTDirectEventBlock onStop;

@end

@implementation RCTStream{
    bool _started;
    bool _cameraFronted;
    NSString *_url;
}

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex
{
    [self insertSubview:view atIndex:atIndex + 1];
}

- (void)removeReactSubview:(UIView *)subview
{
    [subview removeFromSuperview];
}

- (void)removeFromSuperview
{
    if(!_started) {
        [self.session stopLive];
    }
    [super removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (id) initWithManager:(RCTStreamManager *)manager bridge:(RCTBridge *)bridge{
    if ((self = [super init])) {
        _started = NO;
        _cameraFronted = YES;
        self.manager = manager;
        self.bridge = bridge;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
    }
    return self;
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    switch (state) {
        case LFLiveReady:
            if (_onReady) {
                _onReady(@{});
            }
            break;
        case LFLivePending:
            if (_onPending) {
                _onPending(@{});
            }
            break;
        case LFLiveStart:
            if (_onStart) {
                _onStart(@{});
            }
            break;
        case LFLiveError:
            if (_onError) {
                _onError(@{});
            }
            break;
        case LFLiveStop:
            if (_onStop) {
                _onStop(@{});
            }
            break;
        default:
            break;
    }
}

#pragma mark -- Getter Setter
- (LFLiveSession *)session {
    if (!_session) {
        NSLog(@"Session create");
        
        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium3 outputImageOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        videoConfiguration.autorotate = YES;
        
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:videoConfiguration];
        [_session setRunning:YES];
        
        /**    自己定制单声道  */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 1;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_64Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K 分辨率设置为540*960 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(540, 960);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 24;
         videoConfiguration.videoMaxKeyframeInterval = 48;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset540x960;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.landscape = NO;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset360x640;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向横屏  */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(1280, 720);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.landscape = YES;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        _session.delegate = self;
        _session.showDebugInfo = YES;
        _session.preView = self;
        //_session.mirror = NO;
    }
    return _session;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.frame = self.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}


- (void) setStarted:(BOOL) started{
    if(started != _started){
        if(started){
            LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
            stream.url = _url;
            [self.session startLive:stream];
        }else{
            [self.session stopLive];
        }
        _started = started;
    }
}

- (void) setCameraFronted: (BOOL) cameraFronted{
    if(cameraFronted != _cameraFronted){
        if (cameraFronted){
            self.session.captureDevicePosition = AVCaptureDevicePositionFront;
        }else {
            self.session.captureDevicePosition = AVCaptureDevicePositionBack;
        }
        _cameraFronted = cameraFronted;
    }
}

- (void) setUrl: (NSString *) url {
    _url = url;
}

@end
