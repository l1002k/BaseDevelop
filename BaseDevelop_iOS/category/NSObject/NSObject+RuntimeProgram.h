//
//  NSObject+RuntimeProgram.h
//  BaseDevelop
//
//  Created by leikun on 15-4-26.
//  Copyright (c) 2015年 leikun. All rights reserved.
//  thanks Aspects, https://github.com/steipete/Aspects
//

#import <Foundation/Foundation.h>

@interface NSObject (RuntimeProgram)

- (void)swizzleInstanceMethod:(SEL)origSEL to:(SEL)overrideSEL;
+ (void)swizzleClassMethod:(SEL)origSEL to:(SEL)overrideSEL;

/**************************************/
/*下面2个方法是通过运行时删除方法实现，慎用！*/
- (IMP)replaceInstanceMethodToForward:(SEL)selector;
+ (IMP)replaceClassMethodToForward:(SEL)selector;
/**************************************/

@end
