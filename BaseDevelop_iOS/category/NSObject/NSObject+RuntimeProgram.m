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

//这个方法用传入的IMP去替换已经存在的SEL的实现，如果SEL存在，返回替换前的IMP；否则返回NULL
static IMP runtimeProgram_replaceMethodToIMP(Class c, SEL selector, IMP overrideIMP) {
    IMP imp = NULL;
    if (overrideIMP) {
        if (class_respondsToSelector(c, selector)) {
            Method method = class_getInstanceMethod(c, selector);
            imp = method_getImplementation(method);
            const char *encoding = method_getTypeEncoding(method);
            //如果selector是c的super class实现的，class_replaceMethod返回NULL
            class_replaceMethod(c, selector, overrideIMP, encoding);
        } else {
            BOOL isMetaClass = class_isMetaClass(c);
            NSCAssert(NO, @"请检查%@:%@是否存在",isMetaClass?@"类方法":@"对象方法", NSStringFromSelector(selector));
        }
    } else {
        NSCAssert(overrideIMP, @"overrideIMP不能为空");
    }
    return imp;
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

//把selector的方法实现替换成_objc_msgForward或者_objc_msgForward_stret，这样再调用该方法都会走消息转发流程,注意传入的class,类方法请传meta class。如果已替换成消息转发或者seletor不存在，则返回NULL；否则返回selector替换前的方法实现
static IMP runtimeProgram_replaceMethodToForward(Class c, SEL selector) {
    __block IMP result = NULL;
    runtimeProgram_performBlockWithLock(^{
        Method method = class_getInstanceMethod(c, selector);
        IMP imp = method_getImplementation(method);
        if (!runtimeProgram_isMessageForwardIMP(imp)) {
            result = runtimeProgram_replaceMethodToIMP(c, selector, runtimeProgram_getMessageForwardIMP(c, selector));
        }
    });
    return result;
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
        Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
        if (overrideMethod) {
            IMP origIMP = runtimeProgram_replaceMethodToIMP(c, origSEL, method_getImplementation(overrideMethod));
            runtimeProgram_replaceMethodToIMP(c, overrideSEL, origIMP);
        } else {
            BOOL isMetaClass = class_isMetaClass(c);
            NSCAssert(overrideMethod != NULL, @"请检查%@:%@是否存在",isMetaClass?@"类方法":@"对象方法", NSStringFromSelector(overrideSEL));
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
