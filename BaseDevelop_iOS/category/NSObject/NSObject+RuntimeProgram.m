//
//  NSObject+RuntimeProgram.m
//  BaseDevelop
//
//  Created by leikun on 15-4-26.
//  Copyright (c) 2015年 leikun. All rights reserved.
//  thanks Aspects, https://github.com/steipete/Aspects
//

#import "NSObject+RuntimeProgram.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>

@implementation NSObject (RuntimeProgram)

#pragma mark
#pragma mark - 公用方法
//保证线程安全
static void runtimeProgram_performBlockWithLock(dispatch_block_t block) {
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
}

#pragma mark
#pragma mark - 方法删除
//检查IMP是否是forward的函数
static BOOL runtimeProgram_isMessageForwardIMP(IMP implementation) {
    return implementation == _objc_msgForward
#if !defined(__arm64__)
    || implementation == (IMP)_objc_msgForward_stret
#endif
    ;
}

//根据传入的SEL，确定forward函数应该使用哪个，注意传入的class,类方法请传meta class
static IMP runtimeProgram_getMessageForwardIMP(Class c, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(c, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

//把selector的方法实现替换成_objc_msgForward或者_objc_msgForward_stret，这样再调用该方法都会走消息转发流程,注意传入的class,类方法请传meta class
static IMP runtimeProgram_replaceMethodToForward(Class c, SEL selector) {
    if (class_respondsToSelector(c, selector)) {
        __block IMP imp = NULL;
        runtimeProgram_performBlockWithLock(^{
            Method method = class_getInstanceMethod(c, selector);
            const char *encoding = method_getTypeEncoding(method);
            if (!runtimeProgram_isMessageForwardIMP(imp)) {
               imp = class_replaceMethod(c, selector, runtimeProgram_getMessageForwardIMP(c, selector), encoding);
            }
        });
        return imp;
    } else {
        BOOL isMetaClass = class_isMetaClass(c);
        NSCAssert(NO, @"请检查%@:%@是否存在",isMetaClass?@"类方法":@"对象方法", NSStringFromSelector(selector));
        return NULL;
    }
}


- (IMP)replaceInstanceMethodToForward:(SEL)selector {
    return runtimeProgram_replaceMethodToForward(self.class, selector);
}

+ (IMP)replaceClassMethodToForward:(SEL)selector {
    return runtimeProgram_replaceMethodToForward(object_getClass(self.class), selector);
}

#pragma mark
#pragma mark - 方法混淆
static void runtimeProgram_methodSwizzle(Class c, SEL origSEL, SEL overrideSEL) {
    runtimeProgram_performBlockWithLock(^{
        Method origMethod = class_getInstanceMethod(c, origSEL);
        Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
        if (origMethod == NULL || overrideMethod == NULL) {
            BOOL isMetaClass = class_isMetaClass(c);
            NSCAssert(origMethod != NULL, @"请检查%@:%@是否存在", isMetaClass?@"类方法":@"对象方法", NSStringFromSelector(origSEL));
            NSCAssert(overrideMethod != NULL, @"请检查%@:%@是否存在",isMetaClass?@"类方法":@"对象方法", NSStringFromSelector(overrideSEL));
            return ;
        }
        if (class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
            class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, overrideMethod);
        }
    });
}

- (void)swizzleInstanceMethod:(SEL)origSEL to:(SEL)overrideSEL {
    runtimeProgram_methodSwizzle(self.class, origSEL, overrideSEL);
}

+ (void)swizzleClassMethod:(SEL)origSEL to:(SEL)overrideSEL {
    runtimeProgram_methodSwizzle(object_getClass(self.class), origSEL, overrideSEL);
}

#pragma mark
#pragma mark - class混淆

@end
