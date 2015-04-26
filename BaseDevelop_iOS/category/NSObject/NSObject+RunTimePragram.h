//
//  NSObject+RunTimePragram.h
//  BaseDevelop
//
//  Created by leikun on 15-4-26.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RunTimePragram)

- (void)swizzleInstanceMethod:(SEL)origSEL to:(SEL)overrideSEL;
+ (void)swizzleClassMethod:(SEL)origSEL to:(SEL)overrideSEL;

@end
