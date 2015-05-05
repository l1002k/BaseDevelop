//
//  NSObject+RunTimePragram.m
//  BaseDevelop
//
//  Created by leikun on 15-4-26.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSObject+RunTimePragram.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>

@implementation NSObject (RunTimePragram)

void methodSwizzle(Class c, SEL origSEL, SEL overrideSEL, bool isInstanceMethod) {
    Method origMethod, overrideMethod;
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    
    Class swizzleClass;
    if (isInstanceMethod) {
        if (class_isMetaClass(c)) {
            NSCAssert(!class_isMetaClass(c), @"你传入的Class参数一个meta class，这个时候去找的是class method。");
            return;
        }
        origMethod = class_getInstanceMethod(c, origSEL);
        overrideMethod = class_getInstanceMethod(c, overrideSEL);
        swizzleClass = c;
    } else {
        origMethod = class_getClassMethod(c, origSEL);
        overrideMethod = class_getClassMethod(c, overrideSEL);
        swizzleClass = class_isMetaClass(c) ? c:object_getClass(c);
    }
    
    if (origMethod == NULL || overrideMethod == NULL) {
        NSCAssert((origMethod != Nil), @"请检查你要混淆的原函数是否存在");
        NSCAssert((overrideMethod != Nil), @"请检查你要混淆的混淆函数是否存在");
        return;
    }
    
    if (class_addMethod(swizzleClass, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
     class_replaceMethod(swizzleClass, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
    OSSpinLockUnlock(&aspect_lock);
}

- (void)swizzleInstanceMethod:(SEL)origSEL to:(SEL)overrideSEL {
    methodSwizzle(self.class, origSEL, overrideSEL, true);
}

+ (void)swizzleClassMethod:(SEL)origSEL to:(SEL)overrideSEL {
    methodSwizzle(self, origSEL, overrideSEL, false);
}

@end
