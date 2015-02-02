//
//  UIView+Util.m
//  BaseDevelop
//
//  Created by leikun on 15-2-2.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

- (void)removeAllSubViews {
    while (self.subviews.count) {
        UIView *subview = self.subviews.lastObject;
        [subview removeFromSuperview];
    }
}

- (UIView*)descendantOrSelfWithClass:(Class)aClass {
    if ([self isKindOfClass:aClass]) {
        return self;
    }
    
    for (UIView* child in self.subviews) {
        UIView* result = [child descendantOrSelfWithClass:aClass];
        if (result)
            return result;
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)aClass {
    if ([self isKindOfClass:aClass]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:aClass];
        
    } else {
        return nil;
    }
}

- (UIImage*)getSnapshotImage{
    return nil;
}

@end
