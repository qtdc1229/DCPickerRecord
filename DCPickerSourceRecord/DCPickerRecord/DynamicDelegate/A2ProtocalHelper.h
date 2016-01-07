//
//  A2ProtocalHelper.c
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 15/12/24.
//  Copyright © 2015年 dingc. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - Helper functions

static Protocol *a2_classProtocol(Class _cls, NSString *suffix, NSString *description)
{
    Class cls = _cls;
    while (cls) {
        NSString *className = NSStringFromClass(cls);
        NSString *protocolName = [className stringByAppendingString:suffix];
        Protocol *protocol = objc_getProtocol(protocolName.UTF8String);
        if (protocol) return protocol;
        
        cls = class_getSuperclass(cls);
    }
    
    NSCAssert(NO, @"Specify protocol explicitly: could not determine %@ protocol for class %@ (tried <%@>)", description, NSStringFromClass(_cls), [NSStringFromClass(_cls) stringByAppendingString:suffix]);
    return nil;
}

Protocol *a2_dataSourceProtocol(Class cls)
{
    return a2_classProtocol(cls, @"DataSource", @"data source");
}
Protocol *a2_delegateProtocol(Class cls)
{
    return a2_classProtocol(cls, @"Delegate", @"delegate");
}
Protocol *a2_protocolForDelegatingObject(id obj, Protocol *protocol)
{
    NSString *protocolName = NSStringFromProtocol(protocol);
    if ([protocolName hasSuffix:@"Delegate"]) {
        Protocol *p = a2_delegateProtocol([obj class]);
        if (p) return p;
    } else if ([protocolName hasSuffix:@"DataSource"]) {
        Protocol *p = a2_dataSourceProtocol([obj class]);
        if (p) return p;
    }
    
    return protocol;
}