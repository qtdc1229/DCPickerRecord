//
//  A2DynamicDelegate+DCRecorder.m
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 15/12/22.
//  Copyright © 2015年 dingc. All rights reserved.
//
#import <objc/runtime.h>
#import "A2BlockInvocation.h"
#import "DCDynamicDelegate.h"

static BOOL selectorsEqual(const void *item1, const void *item2, NSUInteger(*__unused size)(const void __unused *item))
{
    return sel_isEqual((SEL)item1, (SEL)item2);
}

static NSString *selectorDescribe(const void *item1)
{
    return NSStringFromSelector((SEL)item1);
}
@interface NSMapTable (DCRecorderAdditions)

+ (instancetype)dc_selectorsToSelectorsMapTable;
- (id)bk_objectForSelector:(SEL)aSEL;
- (void)bk_removeObjectForSelector:(SEL)aSEL;
- (void)bk_setObject:(id)anObject forSelector:(SEL)aSEL;

@end;


@implementation NSMapTable (DCRecorderAdditions)

+ (instancetype)dc_selectorsToSelectorsMapTable {
    NSPointerFunctions *selectors = [NSPointerFunctions pointerFunctionsWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
    selectors.isEqualFunction = selectorsEqual;
    selectors.descriptionFunction = selectorDescribe;

    return [[NSMapTable alloc] initWithKeyPointerFunctions:selectors valuePointerFunctions:selectors capacity:1];
}

- (id)bk_objectForSelector:(SEL)aSEL
{
    void *selAsPtr = aSEL;
    return [self objectForKey:(__bridge id)selAsPtr];
}

- (void)bk_removeObjectForSelector:(SEL)aSEL
{
    void *selAsPtr = aSEL;
    [self removeObjectForKey:(__bridge id)selAsPtr];
}

- (void)bk_setObject:(id)anObject forSelector:(SEL)aSEL
{
    void *selAsPtr = aSEL;
    [self setObject:anObject forKey:(__bridge id)selAsPtr];
}

@end

@interface DCDynamicClassDelegate : DCDynamicDelegate

@property (nonatomic) Class proxiedClass;

@end

@interface DCDynamicDelegate ()

@property (nonatomic, readonly) NSMapTable *methodInvocationsBySelectors;
@property (nonatomic) DCDynamicClassDelegate *classProxy;
@property (nonatomic, weak, readwrite) id realDelegate;

- (BOOL) isClassProxy;

@end
@implementation DCDynamicDelegate


- (DCDynamicClassDelegate *)classProxy
{
    if (!_classProxy)
    {
        _classProxy = [[DCDynamicClassDelegate alloc] initWithProtocol:self.protocol];
        _classProxy.proxiedClass = object_getClass(self);
    }
    
    return _classProxy;
}

- (BOOL)isClassProxy
{
    return NO;
}

- (Class)class
{
    Class myClass = object_getClass(self);
    if (myClass == [DCDynamicDelegate class] || [myClass superclass] == [DCDynamicDelegate class])
        return (Class)self.classProxy;
    return [super class];
}

- (id)initWithProtocol:(Protocol *)protocol
{
    _protocol = protocol;
    _handlers = [NSMutableDictionary dictionary];
    _methodInvocationsBySelectors = [NSMapTable dc_selectorsToSelectorsMapTable];
    return self;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSInvocation *methodInvocation = nil;
    if ((methodInvocation = [self.methodInvocationsBySelectors bk_objectForSelector:aSelector])) {
        return methodInvocation.methodSignature;
    }
    else if ([self.realDelegate methodSignatureForSelector:aSelector]) {
        return [self.realDelegate methodSignatureForSelector:aSelector];
    }
    else if (class_respondsToSelector(object_getClass(self), aSelector)) {
        return [object_getClass(self) methodSignatureForSelector:aSelector];
    }
    return [[NSObject class] methodSignatureForSelector:aSelector];
}

+ (NSString *)description
{
    return NSStringFromClass([self class]);
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"<DCDynamicDelegate:%p; protocol = %@>", (__bridge void *)self, NSStringFromProtocol(self.protocol)];
}

- (void)forwardInvocation:(NSInvocation *)outerInv
{
    SEL selector = outerInv.selector;
    NSInvocation *inv = nil;
    if ((inv = [self.methodInvocationsBySelectors bk_objectForSelector:selector])) {
        [inv invokeWithTarget:self];
    }else if ([self.realDelegate respondsToSelector:selector]) {
        [outerInv invokeWithTarget:self.realDelegate];
    }
}

#pragma mark -

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return protocol_isEqual(aProtocol, self.protocol) || [super conformsToProtocol:aProtocol];
}
- (BOOL)respondsToSelector:(SEL)selector
{
    return [self.methodInvocationsBySelectors bk_objectForSelector:selector] || class_respondsToSelector(object_getClass(self), selector) || [self.realDelegate respondsToSelector:selector];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    [NSException raise:NSInvalidArgumentException format:@"-[%s %@]: unrecognized selector sent to instance %p", object_getClassName(self), NSStringFromSelector(aSelector), (__bridge void *)self];
}

#pragma mark - Block Instance Method Implementations

- (id)implementationForMethod:(SEL)selector
{
    NSInvocation *invocation = nil;
    if ((invocation = [self.methodInvocationsBySelectors bk_objectForSelector:selector]))
        return invocation.methodSignature;
    return NULL;
}

- (void)implementMethod:(SEL)selector withMethod:(SEL)anotherSelector
{
    NSCAssert(selector, @"Attempt to implement or remove NULL selector");
    BOOL isClassMethod = self.isClassProxy;
    
    if (!anotherSelector) {
        [self.methodInvocationsBySelectors bk_removeObjectForSelector:selector];
        return;
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(self.protocol, selector, YES, !isClassMethod);
    if (!methodDescription.name) methodDescription = protocol_getMethodDescription(self.protocol, selector, NO, !isClassMethod);
    
    NSInvocation *inv = nil;
    if (methodDescription.name) {
        NSMethodSignature *protoSig = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
        inv = [NSInvocation invocationWithMethodSignature:protoSig];
    }
    
    [self.methodInvocationsBySelectors bk_setObject:inv forSelector:selector];
}
- (void)removeImplementationForMethod:(SEL)selector __unused
{
    [self implementMethod:selector withMethod:nil];
}

@end

#pragma mark -

@implementation DCDynamicClassDelegate

- (BOOL)isClassProxy
{
    return YES;
}
- (BOOL)isEqual:(id)object
{
    return [super isEqual:object] || [_proxiedClass isEqual:object];
}
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self.methodInvocationsBySelectors bk_objectForSelector:aSelector] || [_proxiedClass respondsToSelector:aSelector];
}

- (Class)class
{
    return self.proxiedClass;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSInvocation *methodInvocation = nil;
    if ((methodInvocation = [self.methodInvocationsBySelectors bk_objectForSelector:aSelector]))
        return methodInvocation.methodSignature;
    else if ([_proxiedClass methodSignatureForSelector:aSelector])
        return [_proxiedClass methodSignatureForSelector:aSelector];
    return [[NSObject class] methodSignatureForSelector:aSelector];
}

- (NSString *)description
{
    return [_proxiedClass description];
}

- (NSUInteger)hash
{
    return [_proxiedClass hash];
}

- (void)forwardInvocation:(NSInvocation *)outerInv
{
    SEL selector = outerInv.selector;
    A2BlockInvocation *innerInv = nil;
    NSInvocation *inv = nil;
    if ((innerInv = [self.methodInvocationsBySelectors bk_objectForSelector:selector])) {
        [inv invokeWithTarget:_proxiedClass];
    } else {
        [outerInv invokeWithTarget:_proxiedClass];
    }
}

#pragma mark - Unavailable Methods

- (id)blockImplementationForClassMethod:(SEL)selector
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)implementClassMethod:(SEL)selector withBlock:(id)block
{
    [self doesNotRecognizeSelector:_cmd];
}
- (void)removeBlockImplementationForClassMethod:(SEL)selector
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
