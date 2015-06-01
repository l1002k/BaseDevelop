//
//  NSObject+PerformBlock.h
//  BaseDevelop
//
//  Created by leikun on 15/6/1.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)

- (void)performBlock:(void(^)())block;
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;
- (void)cancelPreviousPerformRequestsWithBlock:(void(^)())block;
- (void)performBlock:(void(^)())block onThread:(NSThread *)thr waitUntilDone:(BOOL)wait;
- (void)performBlockOnMainThread:(void(^)())block waitUntilDone:(BOOL)wait;

@end
