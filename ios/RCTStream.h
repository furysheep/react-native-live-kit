//
//  RCTStream.h
//  RCTLFLiveKit
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCTStreamManager;

@interface RCTStream : UIView

- (id) initWithManager: (RCTStreamManager*) manager bridge:(RCTBridge *) bridge;

@end
