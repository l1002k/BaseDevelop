//
//  NSObject+RunTimePragram.m
//  BaseDevelop
//
//  Created by leikun on 15-4-26.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSObject+RunTimePragram.h"
#import <objc/runtime.h>

@implementation NSObject (RunTimePragram)

void methodSwizzle(Class c, SEL origSEL, SEL overrideSEL, bool isInstanceMethod) {
    Method origMethod, overrideMethod;
    if (isInstanceMethod) {
        origMethod = class_getInstanceMethod(c, origSEL);
        overrideMethod = class_getInstanceMethod(c, overrideSEL);
    } else {
        origMethod = class_getClassMethod(c, origSEL);
        overrideMethod = class_getClassMethod(c, overrideSEL);
    }
    IMP orig = method_getImplementation(origMethod);
    IMP override = method_getImplementation(overrideMethod);
    
    orig = imp_implementationWithBlock(^(id _self, SEL _sel, NSString * string){
        NSLog(@"leikun");
    });
    void(* method)(id, SEL, NSString *) = (void *)orig;
    method(c, origSEL, @"test");
    
    if (class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        method = (void *)class_getMethodImplementation(c, origSEL);
//        method(c, origSEL);
       class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

- (void)swizzleInstanceMethod:(SEL)origSEL to:(SEL)overrideSEL {
    methodSwizzle(self.class, origSEL, overrideSEL, true);
}

+ (void)swizzleClassMethod:(SEL)origSEL to:(SEL)overrideSEL {
    methodSwizzle(self, origSEL, overrideSEL, false);
}

@end
