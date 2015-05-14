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

- (id)descendantOrSelfWithClass:(Class)aClass {
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

- (id)ancestorOrSelfWithClass:(Class)aClass {
    if ([self isKindOfClass:aClass]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:aClass];
    } else {
        return nil;
    }
}

- (UIImage*)getSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (UIView *)getSnapshotView {
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return [self snapshotViewAfterScreenUpdates:NO];
    } else {
        UIImage *snapshotImage = [self getSnapshotImage];
        UIImageView *snapshotImageView = [[UIImageView alloc]initWithImage:snapshotImage];
        snapshotImageView.frame = self.frame;
        return snapshotImageView;
    }
}

- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end
