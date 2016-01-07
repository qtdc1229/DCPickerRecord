//
//  A2DynamicDelegate+DCRecorder.h
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 15/12/22.
//  Copyright © 2015年 dingc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+A2BlockDelegate.h"
#import "NSObject+A2DynamicDelegate.h"

@interface DCDynamicDelegate : NSProxy


- (id)initWithProtocol:(Protocol *)protocol;

/** The protocol delegating the dynamic delegate. */
@property (nonatomic, readonly) Protocol *protocol;

/** A dictionary of custom handlers to be used by custom responders
 in a DCDynamic(Protocol Name) subclass of DCDynamicDelegate, like
 `A2DynamicUIAlertViewDelegate`. */
@property (nonatomic, strong, readonly) NSMutableDictionary *handlers;

/** When replacing the delegate using the DCDynamicDelegate extensions, the object
 responding to classical delegate method implementations. */
@property (nonatomic, weak, readonly) id realDelegate;


- (id)implementationForMethod:(SEL)selector;
@end
