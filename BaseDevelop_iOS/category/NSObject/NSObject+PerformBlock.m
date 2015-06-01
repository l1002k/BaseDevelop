//
//  NSObject+PerformBlock.m
//  BaseDevelop
//
//  Created by leikun on 15/6/1.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSObject+PerformBlock.h"
#import "BDCommonUtil.h"

typedef void(^PBBlock)();

@implementation NSObject (PerformBlock)

- (void)performBlock:(PBBlock)block {
    [self performSelector:@selector(PBFireBlock:) withObject:block];
}

- (void)performBlock:(PBBlock)block afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(PBFireBlock:) withObject:block afterDelay:delay];
}

- (void)cancelPreviousPerformRequestsWithBlock:(PBBlock)block {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(PBFireBlock:) object:block];
}

- (void)performBlock:(PBBlock)block onThread:(NSThread *)thr waitUntilDone:(BOOL)wait {
    [self performSelector:@selector(PBFireBlock:) onThread:thr withObject:block waitUntilDone:wait];
}

- (void)performBlockOnMainThread:(PBBlock)block waitUntilDone:(BOOL)wait {
    [self performSelectorOnMainThread:@selector(PBFireBlock:) withObject:block waitUntilDone:wait];
}

- (void)PBFireBlock:(PBBlock)blcok {
    SafeBlockCall(blcok);
}

@end
