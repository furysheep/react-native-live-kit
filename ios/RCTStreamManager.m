//
//  RCTStreamManager.m
//  RCTLFLiveKit
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import "RCTStreamManager.h"
#import "RCTStream.h"

@implementation RCTStreamManager

RCT_EXPORT_MODULE();

- (UIView *) view
{
    return [[RCTStream alloc] initWithManager:self bridge:self.bridge];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_VIEW_PROPERTY(started, BOOL);
RCT_EXPORT_VIEW_PROPERTY(cameraFronted, BOOL);
RCT_EXPORT_VIEW_PROPERTY(url, NSString);
RCT_EXPORT_VIEW_PROPERTY(onReady, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPending, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStop, RCTDirectEventBlock)

@end
